//
//  ViewModel.swift
//  WOAI
//
//  Created by 양승완 on 11/27/24.
//

import Foundation
import RxSwift
protocol ViewModel {
    
    func transform(input: Input, disposeBag: DisposeBag ) -> Output
    
    associatedtype Input
    associatedtype Output

    var disposeBag: DisposeBag { get set }
        
    
}
