//
//  ViewController.swift
//  Transfrom_07
//
//  Created by xiaoming on 2021/7/11.
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
        let disposeBag = DisposeBag()
        Observable.of("A", "B", "C")
            .toArray()
            .subscribe(onSuccess: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
    private func test2() {
        let disposeBag = DisposeBag()
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        
        Observable<Int>.of(123, 4, 56)
            .map {
                formatter.string(for: $0) ?? ""
            }
            .subscribe(onNext:{
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
}

