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
import Differentiator

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
    
    convenience init(
        account: Driver<TwitterAccount.AccountStatus>,
        username: String,
        apiType: TwitterAPIProtocol.Type
    ) {
        self.init(
            account: account,
            jsonProvider: apiType.timeline(of: username)
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
            paused.asObservable(),
            resultSelector: { _ , reachable, currentAccount, paused in
                return (reachable && !paused) ? account : nil
            })
            .filter { $0 != nil }
            .map { $0! }
        
        let feedCursor = BehaviorRelay<TimeLineCursor>(value: .none)
        
        timeline = reachableTimerWithAccount
            .withLatestFrom(feedCursor.asObservable(), resultSelector: { account, cursor in
                return (account: account, cursor: cursor)
            })
            .flatMapLatest(jsonProvider)
            .map(Tweet.unboxMany(tweets:))
            .share(replay: 1)
        
        timeline
            .scan(.none, accumulator: TimeLineFetcher.currentCursor)
            .bind(to: feedCursor)
            .disposed(by: bag)
    }
    
    static func currentCursor(
        lastCursor: TimeLineCursor,
        tweets: [Tweet]
    ) -> TimeLineCursor {
        return tweets.reduce(lastCursor) { status, tweet in
            let max: Int64 = tweet.id <
                status.maxId ? tweet.id - 1 :
            status.maxId
            let since: Int64 = tweet.id >
            status.sinceId ? tweet.id :
            status.sinceId
            return TimeLineCursor(max: max, since: since)
        }
    }
    
    
}
