//
//  ViewController.swift
//  03_Subject
//
//  Created by  generic on 2021/3/13.
//
import Foundation
import UIKit
import RxSwift
import RxRelay

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
        testTwo()
    }

}

extension ViewController {
    private func testOne() {
        let subject = PublishSubject<String>()
        subject.on(.next("Is anyone listening?"))
        let _ = subject.subscribe { (string) in
            print(string)
        }
        subject.on(.next("1"))
        subject.onNext("2")
    }
    
    private func testTwo() {
        let subject = PublishSubject<String>()
        let subscriptionOne = subject.subscribe { (string) in
            print(string)
        }
        let subscriptionTwo = subject
            .subscribe { (event) in
                print("2)", event.element ?? event)
            }
        subject.onNext("3")
        subscriptionOne.dispose()
        subject.onNext("4")
        subject.onCompleted()
        subject.onNext("5")
        subscriptionTwo.dispose()
        let disposeBag = DisposeBag()
        subject.subscribe {
            print("3)",$0.element ?? $0)
        }
        .disposed(by: disposeBag)
        subject.onNext("?")
    }
    
    private func testThree() {
        
        let subject = BehaviorSubject(value: "Initial value")
        let disposedBag = DisposeBag()
        subject
            .subscribe {
                print(label: "1)", event: $0)
            }
            .disposed(by: disposedBag)
        
        
    }
    
    
}

