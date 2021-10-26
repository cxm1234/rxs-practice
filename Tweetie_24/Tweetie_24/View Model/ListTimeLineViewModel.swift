//
//  ListTimeLineViewModel.swift
//  Tweetie_24
//
//  Created by xiaoming on 2021/10/10.
//

import Foundation

import RealmSwift
import RxSwift
import RxRealm
import RxCocoa

class ListTimeLineViewModel {
    private let bag = DisposeBag()
    private let fetcher: TimeLineFetcher
    
    let list: ListIdentifier
    let account: Driver<TwitterAccount.AccountStatus>
    
    var paused: Bool = false {
        didSet {
            fetcher.paused.accept(paused)
        }
    }
    
    private(set) var tweets:Observable<(AnyRealmCollection<Tweet>,RealmChangeset?)>!
    private(set) var loggedIn: Driver<Bool>!
    
    init(account: Driver<TwitterAccount.AccountStatus>,
         list: ListIdentifier,
         apiType: TwitterAPIProtocol.Type = TwitterAPI.self) {
        self.account = account
        self.list = list
        fetcher = TimeLineFetcher(account: account, list: list, apiType: apiType)
        bindOutput()
        
        fetcher.timeline
            .subscribe(Realm.rx.add(update: .all))
            .disposed(by: bag)
    }
    
    private func bindOutput() {
        guard let realm = try? Realm() else {
            return
        }
        tweets = Observable.changeset(from: realm.objects(Tweet.self))
        
        loggedIn = account
            .map({ status in
                switch status {
                case .unavaliable: return false
                case .authorized: return true
                }
            })
            .asDriver(onErrorJustReturn: false)
    }
    
}


