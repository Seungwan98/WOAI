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
import RxSwift
import RxCocoa

final class WhisperManager {
    
    init(chatGPT: ChatGPTAPI) {
        self.chapGPT = chatGPT
    }
    
    
    let chapGPT: ChatGPTAPI
    
    func getAudioPath(fileName: String) -> URL? {
        // 앱 번들에서 파일 URL 가져오기
        return Bundle.main.url(forResource: fileName, withExtension: "m4a")
    }

   
    func setText(fileName: URL?) -> Single<String> {
        
        return Single.create { single in
          
            Task {
                guard let fileName else {return}
                let pipe = try? await WhisperKit()
                 
                 
              
                   
        
                   let destinationPath = fileName
                   
//                   do {
//                       if !FileManager.default.fileExists(atPath: destinationPath.path) {
//                           try FileManager.default.copyItem(at: bundlePath, to: destinationPath)
//                           print("File copied to: \(destinationPath)")
//                       } else {
//                           print("File already exists at: \(destinationPath)")
//                       }
//        
//                   } catch {
//                       print("Failed to copy file: \(error)")
//                       return
//                   }
                 
             
     //            FileManager.default.urls(for: .documentDirectory , in: .userDomainMask).first!
                 if let transcription = try? await pipe!.transcribe(audioPath: destinationPath.path(), decodeOptions: DecodingOptions(language: "ko" )).first {
                     Task {
                         single(.success(transcription.text))
//                         let stream = try await self.chapGPT.sendMessageStream(text: transcription.text)
//                         for try await message in stream {
//                             print("Stream message: \(message)")
//                         }
                         
                     }
                 }
                 
                 
             }
            
            return Disposables.create()
        }
        
         
    }
}
