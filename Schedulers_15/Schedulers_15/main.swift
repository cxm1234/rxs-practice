//
//  main.swift
//  Schedulers_15
//
//  Created by  generic on 2021/9/13.
//

import Foundation
import RxSwift

print("\n\n\n===== Schedulers =====\n")

let globalScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
let bag = DisposeBag()
let animal = BehaviorSubject(value: "[dog]")

animal
    .dump()
    .dumpingSubscription()
    .disposed(by: bag)

RunLoop.main.run(until: Date(timeIntervalSinceNow: 13))
