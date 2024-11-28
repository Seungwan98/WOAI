//
//  SplashVM.swift
//  MeloMeter
//
//  Created by 양승완 on 2024/05/17.
//

import Foundation
import RxSwift



class MainVM: ViewModel {
 
    let openAIManager = ChatGPTAPI(apiKey: "")
    
    struct Input {
        let text : Observable<String>
        
    }
    
    struct Output {
        
    }
    

  
    var disposeBag = DisposeBag()
  
    
    init() {
        
        
    }
   
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        input.text.subscribe (onNext: { [weak self ] text in
            guard let self else {return}
            do {
                Task {
                    print("text: \(text)")
                    let stream = try await self.openAIManager.sendMessageStream(text: text)
                            for try await message in stream {
                                print("Stream message: \(message)")
                            }

                }
            } catch {
                
                print("err: \(error)")
                
            }

            
            
            
        }).disposed(by: self.disposeBag)
        
        return Output()
    }
        
}
