//
//  ViewController.swift
//  Subjects_03
//
//  Created by xiaoming on 2021/3/2.
//

import UIKit
import RxSwift

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
        test2()
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
}

