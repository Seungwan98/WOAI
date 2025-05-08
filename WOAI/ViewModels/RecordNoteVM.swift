//
//  NoteVM.swift
//  WOAI
//
//  Created by 양승완 on 5/7/25.
//

import Foundation
import Combine
import AVFoundation

struct RecordedModel: Identifiable, Hashable {
    var id: String {name}
    let loadingTime: String
    let name: String
    let url: URL
    
}

class RecordNoteVM: ObservableObject {

    @Published var recordedList: [RecordedModel] = []
    
    
    func onAppear() {
        let files = (try? FileManager.default.contentsOfDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("WOAIRecords"), includingPropertiesForKeys: nil)) ?? []

        Task { @MainActor in
            // .hasPrefix -> 포함되어있으면 true
            self.recordedList = await withTaskGroup(of: RecordedModel.self) { group in
                for file in files where file.lastPathComponent.hasPrefix("recording_") && file.pathExtension == "m4a" {
                    group.addTask {
                        await self.getRecordedModel(url: file)
                    }
                }

                var results: [RecordedModel] = []
                for await model in group {
                    results.append(model)
                }
                return results
            }
        }
       
        print(self.recordedList)
    }
    
    func getDurationString(from url: URL) async -> String {
        let asset = AVURLAsset(url: url)
        do {
            let duration = try await asset.load(.duration)
            let seconds = CMTimeGetSeconds(duration)
            
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.zeroFormattingBehavior = .pad
            
            return formatter.string(from: seconds) ?? "00:00"
        } catch {
            return "00:00"
        }
    }
    
    func getRecordedModel(url: URL) async -> RecordedModel {
        
        let fileName = url.lastPathComponent
        
            let duration = await getDurationString(from: url)
        return RecordedModel(loadingTime: duration, name: fileName, url: url)
    }
}
