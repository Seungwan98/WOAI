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
import SnapKit
import Then

class mainVC: UIViewController, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?
    private let audioSession = AVAudioSession.sharedInstance()
    private var recordingFileURL: URL?
    private var fileName: String  = ""
    
    
    private var recordBtn = UIButton().then {
        $0.setTitle("Record", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .red
    }
    
    @objc
    func record() {
       
        if let recorder = audioRecorder, recorder.isRecording {
            self.stop()

        } else {
            self.recordBtn.setTitle("stop", for: .normal)

            self.fileName = "testing\(UUID()).m4a"
            let fileURL = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask).first!.appendingPathComponent(self.fileName)
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
     
    }
    
    func stop() {
        print("stop")
        self.recordBtn.setTitle("record", for: .normal)
        
     

        audioRecorder?.stop()
        WhisperManager.shared.setText(fileName: "testing")
    }

 
var disposeBag = DisposeBag()
    var text = PublishSubject<String>()
    let tempDir = FileManager.default.temporaryDirectory
    let mainVm = MainVM()
    
    func setUI() {
        
        self.view.addSubview(recordBtn)
        
        recordBtn.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(100)
        }
    }
    
    func setBtns() {
        
        recordBtn.addTarget(self , action: #selector(record), for: .touchUpInside)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try audioSession.setActive(true)
        } catch {
            print("Audio session setup failed: \(error)")
        }
    

        // 권한
        AVAudioApplication.requestRecordPermission(completionHandler: { com in
            if com {
                
                print("권한 설정")
                
            } else {
                
                print("권한 해제" )
                
            }
            
            
        })

        setBindings()
        setUI()
        setBtns()
        
        
       
        
    }
    
    
    private func setBindings() {
        
        let input = MainVM.Input(text: text)
        
        let output = mainVm.transform(input: input, disposeBag: self.disposeBag)
        
        
    }
    
    


}

