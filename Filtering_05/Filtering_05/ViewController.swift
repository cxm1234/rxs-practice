//
//  ViewController.swift
//  Filtering_05
//
//  Created by xiaoming on 2021/6/9.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        testSix()
    }

}

extension ViewController {
    private func testOne() {
        let strikes = PublishSubject<String>()
        let disposeBag = DisposeBag()
        strikes
            .ignoreElements()
            .subscribe {
                print("You're out")
            }
            .disposed(by: disposeBag)
        
        strikes.onNext("X")
        strikes.onNext("X")
        strikes.onNext("X")
        
        strikes.onCompleted()

    }
    
    private func testTwo() {
        let strikes = PublishSubject<String>()
        let disposeBag = DisposeBag()
        
        strikes
            .elementAt(2)
            .subscribe(onNext:{ _ in
                print("You're out")
            })
            .disposed(by: disposeBag)
        
        strikes.onNext("X")
        strikes.onNext("X")
        strikes.onNext("X")

    }
    
    private func testThree() {
        let disposeBag = DisposeBag()
        
        Observable.of(1, 2, 3, 4, 5, 6)
            .filter { $0.isMultiple(of: 2) }
            .subscribe(onNext:{
                print($0)
            })
            .disposed(by: disposeBag)
            
    }
    
    private func testFour() {
        let disposeBag = DisposeBag()
        
        Observable.of("A", "B", "C", "D", "E", "F")
            .skip(3)
            .subscribe(onNext:{
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
    private func testFive() {
        let disposeBag = DisposeBag()
        
        Observable.of(2, 2, 3, 4, 4)
            .skipWhile {
                $0.isMultiple(of: 2)
            }
            .subscribe(onNext:{
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
    private func testSix() {
        let disposeBag = DisposeBag()
        
        let subject = PublishSubject<String>()
        let trigger = PublishSubject<String>()
        
        subject
            .skipUntil(trigger)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        subject.onNext("A")
        subject.onNext("B")
        
        trigger.onNext("X")
        
        subject.onNext("C")
        
    }
}

