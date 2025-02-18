//
//  ViewController.swift
//  WOAI
//
//  Created by 양승완 on 11/26/24.
//

import UIKit
import OpenAI
import RxSwift
import RxCocoa
import AVFAudio
import SnapKit
import Then

class mainVC: UIViewController, AVAudioRecorderDelegate {


    private var label = UILabel().then {
        $0.numberOfLines = 0
    }
    
     var recordBtn = UIButton().then {
        $0.setTitle("Record", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .red
    }
 
    
    var disposeBag = DisposeBag()
    var text = PublishSubject<URL?>()
    let tempDir = FileManager.default.temporaryDirectory
    let mainVm = MainVM()
    
    func setUI() {
        
        self.view.addSubview(recordBtn)
        self.view.addSubview(label)
        
        recordBtn.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(recordBtn.snp.bottom).offset(20)
            $0.trailing.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        setBindings()
        setUI()
        

        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setBindings() {
        let input = MainVM.Input( viewWillAppear: rx.methodInvoked(#selector(self.viewWillAppear(_:))).map { _ in } , recordBtnTapped: self.recordBtn.rx.tap.asObservable())
        
        let output = mainVm.transform(input: input, disposeBag: self.disposeBag)
        
        
        output.getTexts.bind(to: self.label.rx.text).disposed(by: disposeBag)
        
    }
    
    


}

