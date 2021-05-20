//
//  ViewController.swift
//  Subjects_03
//
//  Created by xiaoming on 2021/3/2.
//

import UIKit
import RxSwift
import RxCocoa

enum MyError: Error {
    case anError
}

func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, (event.element ?? event.error) ?? event)
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        test5()
    }

}

extension ViewController {
    private func test1() {
        let subject = PublishSubject<String>()
        subject.onNext("Is anyone listening?")
        let subscriptionOne = subject
            .subscribe { (string) in
                print(string)
            }
        
        subject.on(.next("1"))
        subject.onNext("2")
        
        
        let subscriptionTwo = subject
            .subscribe { event in
                print("2)", event.element ?? event)
            }
        
        subject.on(.next("3"))
        
        subscriptionOne.dispose()
        
        subject.onNext("4")
        
        subject.onCompleted()
        
        subject.onNext("5")
        
        subscriptionTwo.dispose()
        
        let disposeBag = DisposeBag()
        
        subject
            .subscribe {
                print("3)", $0.element ?? $0)
            }
            .disposed(by: disposeBag)
        
        subject.onNext("?")
        
    }
    
    private func test2() {
        let subject = BehaviorSubject(value: "Initial value")
        let disposeBag = DisposeBag()
        
        subject.subscribe {
            print(label: "1)", event: $0)
        }
        .disposed(by: disposeBag)
        
        subject.onNext("X")
        
        subject.onError(MyError.anError)
        
        subject
            .subscribe {
                print(label: "2)", event: $0)
            }
            .disposed(by: disposeBag)
    }
    
    private func test3() {
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        let disposeBag = DisposeBag()
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
        subject
            .subscribe {
                print(label: "1)", event: $0)
            }
            .disposed(by: disposeBag)
        
        subject
            .subscribe {
                print(label: "2)", event: $0)
            }
            .disposed(by: disposeBag)
        
        subject.onNext("4")
        
        subject.onError(MyError.anError)
        
        subject.dispose()
        
        subject
            .subscribe {
                print(label: "3)", event: $0)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func test4() {
        let relay = PublishRelay<String>()
        let disposeBag = DisposeBag()
        
        relay.accept("Knock knock, anyone home?")
        
        relay
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        relay.accept("1")
        
    }
    
    private func test5() {
        let relay = BehaviorRelay(value: "Initial value")
        let disposedBag = DisposeBag()
        
        relay.accept("New initial value")
        
        relay
            .subscribe {
                print(label: "1)", event: $0)
            }
            .disposed(by: disposedBag)
        
        relay.accept("1")
        
        relay
            .subscribe {
                print(label: "2)", event: $0)
            }
            .disposed(by: disposedBag)
        
        relay.accept("2")
        
        print(relay.value)
    }
}

