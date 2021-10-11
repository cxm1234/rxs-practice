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
        self.init(
            account: account,
            jsonProvider: apiType.timeline(of: list)
        )
    }
    
    private init(
        account: Driver<TwitterAccount.AccountStatus>,
        jsonProvider: @escaping (AccessToken, TimeLineCursor) -> Observable<[JSONObject]>
    ) {
        let currentAccount: Observable<AccessToken> = account
            .filter { account in
                switch account {
                case .authorized: return true
                default: return false
                }
            }
            .map { account -> AccessToken in
                switch account {
                case .authorized(let acaccount):
                    return acaccount
                default: fatalError()
                }
            }
            .asObservable()
        
        let reachableTimerWithAccount = Observable.combineLatest(
            Observable<Int>.timer(
                .seconds(0),
                period: .seconds(timerDelay),
                scheduler: MainScheduler.instance
            ),
            Reachability.rx.reachable,
            currentAccount,
            paused.asObservable()) { _, reachable, currentAccount, paused in
                    return (reachable && !paused) ? account : nil
                })

    }
    
    
}
