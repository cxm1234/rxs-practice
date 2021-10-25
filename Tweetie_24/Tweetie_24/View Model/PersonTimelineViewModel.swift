//
//  PersonTimelineViewModel.swift
//  Tweetie_24
//
//  Created by xiaoming on 2021/10/26.
//

import Foundation

import RxSwift
import RxCocoa

class PersonTimelineViewModel {
    private let fetcher: TimeLineFetcher
    
    let username: String
    
    let account: Driver<TwitterAccount.AccountStatus>
    
    public var tweets: Driver<[Tweet]>!
    
    init(account: Driver<TwitterAccount.AccountStatus>,
         username: String,
         apiType:TwitterAPIProtocol.Type = TwitterAPI.self) {
        self.account = account
        self.username = username
        
        fetcher = TimeLineFetcher(
            account: account,
            username: username,
            apiType: apiType
        )
    }
}
