//
//  AudioManager.swift
//  WOAI
//
//  Created by 양승완 on 12/4/24.
//

import AVFAudio
import AVFoundation
import Foundation
import WhisperKit
final class WhisperManager {
    
    static let shared = WhisperManager()
    
    let chapGPT = ChatGPTAPI(apiKey: "")
    
    func getAudioPath(fileName: String) -> URL? {
        // 앱 번들에서 파일 URL 가져오기
        return Bundle.main.url(forResource: fileName, withExtension: "m4a")
    }

   
    func setText(fileName: String) {
        Task {
           let pipe = try? await WhisperKit()
            
            
            guard let bundlePath = Bundle.main.url(forResource: fileName, withExtension: "m4a") else {
                  print("File not found in bundle.")
                  return
              }
            print("bundlePath \(bundlePath)")
              
              let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
              let destinationPath = documentsPath.appendingPathComponent(fileName + ".m4a")
              
              do {
                  if !FileManager.default.fileExists(atPath: destinationPath.path) {
                      try FileManager.default.copyItem(at: bundlePath, to: destinationPath)
                      print("File copied to: \(destinationPath)")
                  } else {
                      print("File already exists at: \(destinationPath)")
                  }
   
              } catch {
                  print("Failed to copy file: \(error)")
                  return
              }
            
        
//            FileManager.default.urls(for: .documentDirectory , in: .userDomainMask).first!
            if let transcription = try? await pipe!.transcribe(audioPath: bundlePath.path(), decodeOptions: DecodingOptions(language: "ko")).first {
                Task {
                    let stream = try await chapGPT.sendMessageStream(text: transcription.text)
                    for try await message in stream {
                        print("Stream message: \(message)")
                    }
                    
                }
            }
            
            
        }
    }
}
