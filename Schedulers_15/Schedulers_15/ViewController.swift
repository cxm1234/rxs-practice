//
//  ViewController.swift
//  Schedulers_15
//
//  Created by xiaoming on 2021/9/13.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        testOne()
    }

}

extension ViewController {
    private func testOne() {
        print("\n\n\n===== Schedulers =====\n")
        
        let globalScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
        let bag = DisposeBag()
        let animal = BehaviorSubject(value: "[dog]")
        animal
            .subscribeOn(MainScheduler.instance)
            .dump()
            .observeOn(globalScheduler)
            .dumpingSubscription()
            .disposed(by: bag)
        
        let fruit = Observable<String>.create { observer in
            observer.onNext("[apple]")
            sleep(2)
            observer.onNext("[pineapple]")
            sleep(2)
            observer.onNext("[strawberry]")
            return Disposables.create()
        }
        
        fruit
            .subscribeOn(globalScheduler)
            .dump()
            .observeOn(MainScheduler.instance)
            .dumpingSubscription()
            .disposed(by: bag)
        
        let animalsThread = Thread() {
            sleep(3)
            animal.onNext("[cat]")
            sleep(3)
            animal.onNext("[tiger]")
            sleep(3)
            animal.onNext("[fox]")
            sleep(3)
            animal.onNext("[leopard]")
        }
        
        animalsThread.name = "Animals Thread"
        animalsThread.start()
        
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 13))
    }
    
    
    
}



