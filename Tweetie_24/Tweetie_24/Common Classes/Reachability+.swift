//
//  Reachability+.swift
//  Tweetie_24
//
//  Created by  generic on 2021/10/11.
//

import Foundation
import Reachability
import RxSwift

extension Reachability {
    enum Errors: Error {
        case unavailable
    }
}

extension Reactive where Base: Reachability {
    
    static var reachable: Observable<Bool> {
        return Observable.create { observer in
            
            
        }
    }
}
