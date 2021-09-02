//
//  ViewController.swift
//  Wundercast_12
//
//  Created by xiaoming on 2021/8/29.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var searchCityName: UITextField!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        style()
        
        let searchInput = searchCityName.rx
            .controlEvent(.editingDidEndOnExit)
            .map { self.searchCityName.text ?? "" }
            .filter { !$0.isEmpty }
        
        
        let search = searchInput
            .flatMapLatest{ text in
                ApiController.shared
                    .currentWeather(for: text)
                    .catchErrorJustReturn(.empty)
            }
            .asDriver(onErrorJustReturn: .empty)
        
        
        let running = Observable.merge(
            searchInput.map{ _ in true },
            search.map { _ in false }.asObservable()
        )
        .startWith(true)
        .asDriver(onErrorJustReturn: false)
        
        running
            .skip(1)
//            .drive(activ)
        
        search.map{ "\($0.temperature)℃" }
            .drive(tempLabel.rx.text)
            .disposed(by: bag)
        
        search.map(\.icon)
            .drive(cityNameLabel.rx.text)
            .disposed(by: bag)
        
        search.map { "\($0.humidity)%"}
            .drive(humidityLabel.rx.text)
            .disposed(by: bag)
        
        search.map(\.cityName)
            .drive(cityNameLabel.rx.text)
            .disposed(by: bag)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Appearance.applyBottomLine(to: searchCityName)
    }

    private func style() {
        view.backgroundColor = .aztec
        searchCityName.attributedPlaceholder =
            NSAttributedString(string: "", attributes: [
                .foregroundColor: UIColor.textGrey
            ])
        searchCityName.textColor = .ufoGreen
        tempLabel.textColor = .cream
        humidityLabel.textColor = .cream
        iconLabel.textColor = .cream
    }
}

