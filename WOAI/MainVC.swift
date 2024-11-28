//
//  ViewController.swift
//  WOAI
//
//  Created by 양승완 on 11/26/24.
//

import UIKit
import OpenAI
import WhisperKit
import RxSwift
class mainVC: UIViewController {
    
    
var disposeBag = DisposeBag()
    var text = PublishSubject<String>()
    
    let mainVm = MainVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBindings()
      
        Task {
           let pipe = try? await WhisperKit()
            
            
            
        
            
           

          
            let transcription = try? await pipe!.transcribe(audioPath: "/Users/seungwan/xcode/WOAI/WOAI/testAudio_0.mp3", decodeOptions: DecodingOptions(language: "ko"))?.text
            
            text.onNext(transcription ?? "")
            
            
        }
    }
    
    
    private func setBindings() {
        
        let input = MainVM.Input(text: text)
        
        let output = mainVm.transform(input: input, disposeBag: self.disposeBag)
        
        
    }
    
    


}

