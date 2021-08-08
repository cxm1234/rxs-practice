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
        testFivteen()
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
    
    private func testSix() {
        let left = PublishSubject<String>()
        let right = PublishSubject<String>()
        
        let observable = Observable.combineLatest(left, right) { lastLeft, lastRight in
            "\(lastLeft) \(lastRight)"
        }
        
        _ = observable.subscribe(onNext: { value in
            print(value)
        })
        
        print("> Sending a value to Left")
        left.onNext("Hello,")
        print("> Sending a value to Right")
        right.onNext("world")
        print("> Sending another value to Right")
        right.onNext("RxSwift")
        print("> Sending another value to Left")
        left.onNext("Have a good day,")
        
        left.onCompleted()
        right.onCompleted()
        
    }
    
    private func TestSeven() {
        let choice: Observable<DateFormatter.Style> = Observable.of(.short, .long)
        let dates = Observable.of(Date())
        
        let observable = Observable.combineLatest(choice, dates) { format, when -> String in
            let formatter = DateFormatter()
            formatter.dateStyle = format
            return formatter.string(from: when)
        }
        
        _ = observable.subscribe(onNext: { value in
            print(value)
        })
    }
    
    private func TestEight() {
        enum Weather {
            case cloudy
            case sunny
        }
        
        let left: Observable<Weather> = Observable.of(.sunny, .cloudy, .cloudy, .sunny)
        let right = Observable.of("Lisbon", "Copenhagen", "London", "Madrid", "Vienna")
        let observable = Observable.zip(left, right) { weather, city in
            return "It's \(weather) in \(city)"
        }
        _ = observable.subscribe(onNext: { value in
            print(value)
        })
        
    }
    
    private func TestTen() {
        let button = PublishSubject<Void>()
        let textField = PublishSubject<String>()
        
        let observable = button.withLatestFrom(textField)
        _ = observable.subscribe(onNext: { value in
            print(value)
        })
        
        textField.onNext("Par")
        textField.onNext("Pari")
        textField.onNext("Paris")
        button.onNext(())
        button.onNext(())
    }
    
    private func TestEleven() {
        let button = PublishSubject<Void>()
        let textField = PublishSubject<String>()
        
        let observable = textField.sample(button)
        _ = observable.subscribe(onNext: { value in
            print(value)
        })
        
        textField.onNext("Par")
        textField.onNext("Pari")
        textField.onNext("Paris")
        button.onNext(())
        button.onNext(())
    }
    
    private func TestTwelve() {
        let left = PublishSubject<String>()
        let right = PublishSubject<String>()
        
        let observable = left.amb(right)
        _ = observable.subscribe(onNext: { value in
            print(value)
        })
        
        left.onNext("Lisbon")
        right.onNext("Copenhagen")
        left.onNext("London")
        left.onNext("Madrid")
        right.onNext("Vienna")
        
        left.onCompleted()
        right.onCompleted()
    }
    
    private func testThirteen() {
        let one = PublishSubject<String>()
        let two = PublishSubject<String>()
        let three = PublishSubject<String>()
        
        let source = PublishSubject<Observable<String>>()
        
        let observable = source.switchLatest()
        let disposable = observable.subscribe(onNext: { value in
            print(value)
        })
        
        source.onNext(one)
        one.onNext("Some text from sequence one")
        two.onNext("Some text from sequence two")
        
        source.onNext(two)
        two.onNext("More text from sequence two")
        one.onNext("and also from sequence one")
        
        source.onNext(three)
        two.onNext("Why don't you see me?")
        one.onNext("I'm alone, help me")
        three.onNext("Hey it's three. I win.")
        
        source.onNext(one)
        one.onNext("Nope. It's me, one!")
        
        disposable.dispose()
        
    }
    
    private func testFourteen() {
        let source = Observable.of(1, 3, 5, 7, 9)
        let observable = source.reduce(0, accumulator: + )
        _ = observable.subscribe(onNext: { value in
            print(value)
        })
    }
    
    private func testFivteen() {
        let source = Observable.of(1, 3, 5, 7, 9)
        let observable = source.scan(0, accumulator: +)
        _ = observable.subscribe(onNext: { value in
            print(value)
        })
    }
    
    
}

