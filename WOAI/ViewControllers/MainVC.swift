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
import AVFAudio
class mainVC: UIViewController, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?
    private let audioSession = AVAudioSession.sharedInstance()
    private var recordingFileURL: URL?
    func record() {
        let fileName = "testing\(UUID()).wav"
        let fileURL = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask).first!.appendingPathComponent(fileName)
                recordingFileURL = fileURL
                
                let settings: [String: Any] = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                
                do {
                    audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
                    audioRecorder?.delegate = self
                    audioRecorder?.record()
                    print("Recording started at \(fileURL)")
                } catch {
                    print("Failed to start recording: \(error)")
                }
    }
    
    func stop() {
        print("stop")
        audioRecorder?.stop()
    }

 
var disposeBag = DisposeBag()
    var text = PublishSubject<String>()
    let tempDir = FileManager.default.temporaryDirectory
    let mainVm = MainVM()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    

        // 권한
        AVAudioSession.sharedInstance().requestRecordPermission { (accepted) in
            if accepted {
                print("permission granted")
            }
        }

        setBindings()
        record()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
            
            self.stop()
        } )
//        Task {
//           let pipe = try? await WhisperKit()
//            
//            
//            
//        
//            
//           
//
//          
//            let transcription = try? await pipe!.transcribe(audioPath: "/Users/seungwan/xcode/WOAI/WOAI/testAudio_0.mp3", decodeOptions: DecodingOptions(language: "ko"))?.text
//            
//            text.onNext(transcription ?? "")
//            
//            
//        }
    }
    
    
    private func setBindings() {
        
        let input = MainVM.Input(text: text)
        
        let output = mainVm.transform(input: input, disposeBag: self.disposeBag)
        
        
    }
    
    


}

