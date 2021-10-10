//
//  TimeLineFetcher.swift
//  Tweetie_24
//
//  Created by xiaoming on 2021/10/10.
//

import Foundation

import RxSwift
import RxCocoa
import RxRealm

import RealmSwift
import Reachability
import Unbox

class TimeLineFetcher {
    
    private let timerDelay = 30
    private let bag = DisposeBag()
    private let feedCursor = BehaviorRelay<TimeLineCursor>(value: .none)
    
    let paused = BehaviorRelay<Bool>(value: false)
    
    let timeline: Observable<[Tweet]>
    
    convenience init(
        account: Driver<TwitterAccount.AccountStatus>,
        list: ListIdentifier,
        apiType: TwitterAPIProtocol.Type
    ) {
        self.init(account: account, list: <#T##ListIdentifier#>, apiType: <#T##TwitterAPIProtocol.Type#>)
    }
    
    private init(account: Driver<TwitterAccount.AccountStatus>, jsonProvider: @escaping (AccessToken, TimeLineCursor) -> Observable<[JSONObject]>) {
        
    }
    
    
}
