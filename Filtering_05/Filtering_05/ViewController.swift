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
        testTwelve()
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
    
    private func testSeven() {
        let disposeBag = DisposeBag()
        Observable.of(1, 2, 3, 4, 5, 6)
            .take(3)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
    private func testEight() {
        let disposeBag = DisposeBag()
        Observable.of(2, 2, 4, 4, 6, 6)
            .enumerated()
            .takeWhile { index, integer in
                integer.isMultiple(of: 2) && index < 3
            }
            .map(\.element)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
    private func testNine() {
        let disposeBag = DisposeBag()
        Observable.of(1, 2, 3, 4, 5)
            .takeUntil(.exclusive) { $0.isMultiple(of: 4) }
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
    private func testTen() {
        let disposeBag = DisposeBag()
        let subject = PublishSubject<String>()
        let trigger = PublishSubject<String>()
        
        subject
            .takeUntil(trigger)
            .subscribe(onNext:{
                print($0)
            })
            .disposed(by: disposeBag)
        
        subject.onNext("1")
        subject.onNext("2")
        
        trigger.onNext("X")
        
        subject.onNext("3")
        
    }

    private func testEleven() {
        let disposeBag = DisposeBag()
        Observable.of("A", "A", "B", "B", "A")
            .distinctUntilChanged()
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func testTwelve() {
        let disposeBag = DisposeBag()
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        
        Observable<NSNumber>.of(10, 110, 20, 200, 210, 310)
            .distinctUntilChanged { a, b in
                guard let aWords = formatter.string(from: a)?.components(separatedBy: " "),
                      let bWords = formatter.string(from: b)?.components(separatedBy: " ") else {
                    return false
                }
                
                var containsMatch = false
                
                for aWord in aWords where bWords.contains(aWord) {
                    containsMatch = true
                    break
                }
                
                return containsMatch
            }
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
}

