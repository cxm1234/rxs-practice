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
    
    init(account: Driver<TwitterAccount.AccountStatus>,
         list: ListIdentifier,
         apiType: TwitterAPIProtocol.Type = TwitterAPI.self) {
        
        fetcher = TimeLineFetcher(account: account, list: list, apiType: apiType)
        bindOutput()
        
    }
    
    private func bindOutput() {
        
    }
    
}


