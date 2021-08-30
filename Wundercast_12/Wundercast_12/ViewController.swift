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
        ApiController.shared.currentWeather(for: "London")
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { data in
                self.tempLabel.text = "\(data.temperature)℃"
                self.iconLabel.text = data.icon
                self.humidityLabel.text = "\(data.humidity)%"
                self.cityNameLabel.text = data.cityName
            })
            .disposed(by: bag)
        
        let search = searchCityName.rx.text.orEmpty
            .filter { !$0.isEmpty }
            .flatMapLatest{ text in
                ApiController.shared
                    .currentWeather(for: text)
                    .catchErrorJustReturn(.empty)
            }
            .share(replay: 1)
            .observeOn(MainScheduler.instance)
        
        search.map { "\($0.temperature)℃" }
            .bind(to: tempLabel.rx.text)
            .disposed(by: bag)
        
        search.map(\.icon)
            .bind(to: cityNameLabel.rx.text)
            .disposed(by: bag)
        
        search.map { "\($0.humidity)%"}
            .bind(to: humidityLabel.rx.text)
            .disposed(by: bag)
        
        search.map(\.cityName)
            .bind(to: cityNameLabel.rx.text)
            .disposed(by: bag)
        
        
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

