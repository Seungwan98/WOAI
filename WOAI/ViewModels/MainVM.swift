//
//  SplashVM.swift
//  MeloMeter
//
//  Created by 양승완 on 2024/05/17.
//

import Foundation
import RxSwift
import AVFAudio



class MainVM: ViewModel {
    private var audioRecorder: AVAudioRecorder?
    private let audioSession = AVAudioSession.sharedInstance()
    private var recordingFileURL: URL?
    private var fileName: String  = ""
    
    private var url = BehaviorSubject<URL?>(value: nil)

    
    let openAIManager: ChatGPTAPI
    let whisperManager: WhisperManager
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let recordBtnTapped: Observable<Void>
    }
    
    struct Output {
        var getTexts = BehaviorSubject<String>(value: "")
    }
    
    
    
    var disposeBag = DisposeBag()
    
    
    init() {
        self.openAIManager = ChatGPTAPI(apiKey: Environment.chatGPTApiKey)
        self.whisperManager = WhisperManager(chatGPT: self.openAIManager)
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        input.viewWillAppear.subscribe({ [weak self] _ in
            guard let self else {return}
            
            do {
                try self.audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
                try self.audioSession.setActive(true)
            } catch {
                print("Audio session setup failed: \(error)")
            }
        

            // MARK: - 권한
            AVAudioApplication.requestRecordPermission(completionHandler: { com in
                if com {
                    print("권한 설정")
                } else {
                    print("권한 해제" )
                }
            })
        }).disposed(by: disposeBag)
        
        input.recordBtnTapped.subscribe({ [weak self]_ in
            guard let self else {return}
            if let recorder = audioRecorder, recorder.isRecording {
                
                self.stop()
                
            } else {
                
            
                self.fileName = "testing\(UUID()).m4a"
                let fileURL = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask).first!.appendingPathComponent(self.fileName)
                self.recordingFileURL = fileURL
                
                
                
                let settings: [String: Any] = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                
                do {
                    self.audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
                   // self.audioRecorder?.delegate = self
                    self.audioRecorder?.record()
                    
                } catch {
                    print("Failed to start recording: \(error)")
                }
                
            }
        }).disposed(by: disposeBag)
        
        
        url.subscribe (onNext: { [weak self ] url in
            guard let self else {return}

            self.whisperManager.setText(fileName: url).subscribe({ single in
                
                switch single {
                case .success(let text):
                    do {
                        Task {
                            var texts = ""
                            let stream = try await self.openAIManager.sendMessageStream(text: text)
                            for try await message in stream {
                                texts += message
                            }
                            
                            output.getTexts.onNext(texts)
                        }
                    }
                    
                
                case .failure(let err):
                    print(err)
                }
                
            }).disposed(by: disposeBag)
            
            
        
            
            
            
        }).disposed(by: self.disposeBag)
        
        return output
    }
    
    
       
       func stop() {
     
           audioRecorder?.stop()
           url.onNext(recordingFileURL)
       }
    
}
