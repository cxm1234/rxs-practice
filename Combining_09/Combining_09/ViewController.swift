//
//  ViewController.swift
//  Combining_09
//
//  Created by xiaoming on 2021/7/17.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        testFive()
    }
    
}

extension ViewController {
    private func testOne() {
        let numbers = Observable.of(2, 3, 4)
        
        let observable = numbers.startWith(1)
        _ = observable.subscribe(onNext: { value in
            print(value)
        })
    }
    
    private func testTwo() {
        let first = Observable.of(1, 2, 3)
        let second = Observable.of(4, 5, 6)
        
        let observable = Observable.concat([first, second])
        _ = observable.subscribe(onNext: { value in
            print(value)
        })
    }
    
    private func testThree() {
        let germanCities = Observable.of("Berlin", "Munich", "Frankfurt")
        let spanishCities = Observable.of("Madrid", "Barcelona", "Valencia")
        
        let observable = germanCities.concat(spanishCities)
        _ = observable.subscribe(onNext: { value in
            print(value)
        })
    }
    
    private func testFour() {
        let sequences = [
            "German cities": Observable.of("Berlin", "Münich", "Frankfurt"),
            "Spanish cities": Observable.of("Madrid", "Barcelona", "Valencia")
        ]
        
        let observable = Observable.of("German cities", "Spanish cities")
            .concatMap { country in
                sequences[country] ?? .empty()
            }
        _ = observable.subscribe(onNext: { string in
            print(string)
        })
    }
    
    private func testFive() {
        let left = PublishSubject<String>()
        let right = PublishSubject<String>()
        
        let source = Observable.of(left.asObserver(), right.asObserver())
        let observable = source.merge()
        _ = observable.subscribe(onNext: { value in
            print(value)
        })
        
        var leftValues = ["Berlin", "Munich", "Frankfurt"]
        var rightValues = ["Madrid", "Barcelona", "Valencia"]
        repeat {
            switch Bool.random() {
            case true where !leftValues.isEmpty:
                left.onNext("Left: " + leftValues.removeFirst())
            case false where !rightValues.isEmpty:
                right.onNext("Right: " + rightValues.removeFirst())
            default:
                break
            }
        } while !leftValues.isEmpty || !rightValues.isEmpty
        
        left.onCompleted()
        right.onCompleted()
    }
}

