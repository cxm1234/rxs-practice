//
//  ViewController.swift
//  Subjects_03
//
//  Created by xiaoming on 2021/3/2.
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
        let subject = PublishSubject<String>()
        subject.onNext("Is anyone listening?")
        let _ = subject
            .subscribe { (string) in
                print(string)
            }
        
        subject.on(.next("1"))
        subject.onNext("2")
    }
}

