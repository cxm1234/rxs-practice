//
//  ListPeopleViewModel.swift
//  Tweetie_24
//
//  Created by xiaoming on 2021/10/16.
//

import Foundation
import RxSwift
import RxCocoa
import Unbox

class ListPeopleViewModel {
    private let bag = DisposeBag()
    
    let list: ListIdentifier
    let apiType: TwitterAPIProtocol.Type
    
    let account: Driver<TwitterAccount.AccountStatus>
    
    let people = BehaviorRelay<[User]?>(value: nil)
    
    init(account: Driver<TwitterAccount.AccountStatus>,
         list: ListIdentifier,
         apiType: TwitterAPIProtocol.Type = TwitterAPI.self) {
        self.account = account
        self.list = list
        self.apiType = apiType
        
        bindOutput()
    }
    
    func bindOutput() {
        let currentAccount = account
            .filter { account in
                switch account {
                case .authorized: return true
                default: return false
                }
            }
            .map{ account -> AccessToken in
                switch account {
                case .authorized(let acaccount):
                    return acaccount
                default: fatalError()
                }
            }
            .distinctUntilChanged()
        
        currentAccount.asObservable()
            .flatMapLatest(apiType.members(of: list))
            .map { users in
                return (try? unbox(dictionaries: users, allowInvalidElements: true) as [User]) ?? []
            }
            .bind(to: people)
            .disposed(by: bag)
    }
    
    
}
