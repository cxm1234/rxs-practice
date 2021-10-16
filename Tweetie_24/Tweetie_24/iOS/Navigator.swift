//
//  Navigator.swift
//  Tweetie_24
//
//  Created by xiaoming on 2021/10/10.
//

import Foundation
import UIKit

import RxCocoa

class Navigator {
    lazy private var defaultStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    enum Segue {
        case listTimeline(Driver<TwitterAccount.AccountStatus>, ListIdentifier)
        case listPeople(Driver<TwitterAccount.AccountStatus>, ListIdentifier)
        case personTimeline(Driver<TwitterAccount.AccountStatus>, ListIdentifier)
    }
    
    func show(seque: Segue, sender: UIViewController) {
        switch seque {
        case .listTimeline(let account, let list):
            let vm = ListTimeLineViewModel(account: account, list: list)
//            show
        case .listPeople(let driver, let listIdentifier):
            <#code#>
        case .personTimeline(let driver, let listIdentifier):
            <#code#>
        }
    }
}
