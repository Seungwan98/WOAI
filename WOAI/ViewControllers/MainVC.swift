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
    
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    
    private var label = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        
    }
    
    var recordBtn = UIButton().then {
        $0.setTitle("record", for: .normal)
        $0.setTitle("stop", for: .selected)
        
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 50
        $0.isSelected = false
    }
    
    
    var disposeBag = DisposeBag()
    var text = PublishSubject<URL?>()
    let tempDir = FileManager.default.temporaryDirectory
    let mainVm = MainVM()
    
    func setUI() {
        
        self.view.addSubview(recordBtn)
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        self.contentView.addSubview(label)
        
        
        recordBtn.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(recordBtn.snp.bottom).offset(20)
            $0.trailing.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.width.equalToSuperview()
        }
        label.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
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
        
        
        let input = MainVM.Input( viewWillAppear: rx.methodInvoked(#selector(self.viewWillAppear(_:))).map { _ in } , recordBtnTapped: self.recordBtn.rx.tap.map { _ in
            
            if !self.recordBtn.isSelected {
                self.recordBtn.isSelected = true
                self.label.text = "\n녹음중..."
            } else {
                self.recordBtn.isSelected = false
                self.label.text = "\n분석중..."

                
            }
            
        }.asObservable())
        
        let output = mainVm.transform(input: input, disposeBag: self.disposeBag)
        
        
        output.getTexts.bind(to: self.label.rx.text).disposed(by: disposeBag)
        
    }
    
    
    
    
}

