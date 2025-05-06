//
//  NoteVM.swift
//  WOAI
//
//  Created by 양승완 on 5/7/25.
//

import Foundation
import Combine

class RecordedModel {
    
}

class RecordNoteVM: ObservableObject {

    @Published var recordedList: [String] = []
    
    
    func onAppear() {
        let files = (try? FileManager.default.contentsOfDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("WOAIRecords"), includingPropertiesForKeys: nil)) ?? []

        
        // .hasPrefix -> 포함되어있으면 true
        self.recordedList = files.filter { $0.lastPathComponent.hasPrefix("recording_") && $0.pathExtension == "m4a" }.map { $0.lastPathComponent }
        print(self.recordedList)
    }
}
