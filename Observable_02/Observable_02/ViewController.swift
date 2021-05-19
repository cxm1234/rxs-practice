//
//  ViewController.swift
//  Observable_02
//
//  Created by xiaoming on 2021/2/23.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        test1()
    }
}

extension ViewController {
    private func test1() {
        print("start for test1")
        let one = 1
        let two = 2
        let three = 3
        let observable = Observable.just(one)
        let observable2 = Observable.of(one, two, three)
        let observable3 = Observable.of([one, two, three])
        let observable4 = Observable.from([one, two, three])
    }
    
    private func test2() {
        print("start for test2")
        let one = 1
        let two = 2
        let three = 3
        let observable = Observable.of(one, two, three)
        _ = observable.subscribe { (event) in
            print(event)
        }
    }
    
    private func test3() {
        let one = 1
        let two = 2
        let three = 3
        let observable = Observable.of(one, two, three)
        _ = observable.subscribe({ (event) in
            if let element = event.element {
                print(element)
            }
        })
    }
    
    private func test4() {
        print("start for test4")
        let one = 1
        let two = 2
        let three = 3
        let observable = Observable.of(one, two, three)
        _ = observable.subscribe(onNext: { (element) in
            print(element)
        })
    }
    
    private func test5() {
        let observable = Observable<Void>.empty()
        _ = observable.subscribe (
            onNext: { (element) in
                print(element)
            },
            onCompleted: {
                print("Completed")
            }
        )
    }
    
    private func test6() {
        let observable = Observable<Int>.range(start: 1, count: 10)
        _ = observable.subscribe(onNext: { i in
            let n = Double(i)
            let fibonacci = Int(
                ((pow(1.61803, n) - pow(0.61803, n)) /
                 2.23606).rounded()
            )
            print(fibonacci)
        })
    }
    
    private func test7() {
        let observable = Observable.of("A", "B", "C")
        let subscription = observable.subscribe { (event) in
            print(event)
        }
        print(type(of: subscription))
        subscription.dispose()
    }
    
    private func test8() {
        let disposeBag = DisposeBag()
        Observable.of("A", "B", "C")
            .subscribe {
                print($0)
            }
            .disposed(by: disposeBag)
    }
    
    private func test9() {
        
        enum MyError: Error {
            case anError
        }
        
        let disposaBag = DisposeBag()
        
        _ = Observable<String>.create { (observer) -> Disposable in
            observer.onNext("1")
//            observer.onError(MyError.anError)
//            observer.onCompleted()
            observer.onNext("?")
            return Disposables.create()
        }.subscribe(onNext: {
            print($0)
        }, onError: {
            print($0)
        }, onCompleted: {
            print("Completed")
        }, onDisposed: {
            print("Disposed")
        })
//        .disposed(by: disposaBag)
        
    }
    
    private func test10() {
        let disposeBag = DisposeBag()
        var flip = false
        
        let factory: Observable<Int> = Observable.deferred {
            flip.toggle()
            
            if flip {
                return Observable.of(1, 2, 3)
            } else {
                return Observable.of(4, 5, 6)
            }
        }
        
        for _ in 0...3 {
            factory.subscribe(onNext: {
                print($0, terminator: "")
            })
            .disposed(by: disposeBag)
            
            print()
        }
    }
    
    private func test11() {
        let disposeBag = DisposeBag()
        
        enum FileReadError: Error {
            case fileNotFound, unreadable, encodingFailed
        }
        
        func loadText(from name: String) -> Single<String> {
            return Single.create { (single) -> Disposable in
                let disposable = Disposables.create()
                
                guard let path = Bundle.main.path(forResource: name, ofType: "txt")
                else {
                    single(.failure(FileReadError.fileNotFound))
                    return disposable
                }
                
                guard let data = FileManager.default.contents(atPath: path) else {
                    single(.failure(FileReadError.unreadable))
                    return disposable
                }
                
                guard let contents = String(data: data, encoding: .utf8) else {
                    single(.failure(FileReadError.encodingFailed))
                    return disposable
                }

                single(.success(contents))
                return disposable
            }
        }
        
        loadText(from: "Copyright")
            .subscribe {
                switch $0 {
                case .success(let string):
                    print(string)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func test12() {
        let observable = Observable<Any>.never()
        let disposeBag = DisposeBag()
        
        observable
            .do(onSubscribe: {
                print("Subscribed")
            })
            .subscribe(
                onNext: { (element) in
                    print(element)
                },
                onCompleted: {
                    print("Completed")
                },
                onDisposed: {
                    print("Disposed")
                }
            )
            .disposed(by: disposeBag)
    }
    
}

