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
        test2()
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
}

