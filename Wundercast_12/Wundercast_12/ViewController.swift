//
//  ViewController.swift
//  Wundercast_12
//
//  Created by xiaoming on 2021/8/29.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var searchCityName: UITextField!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var geoLocationButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    private let bag = DisposeBag()
    
    private let locationManager = CLLocationManager()
    
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
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: bag)
        
        running
            .drive(tempLabel.rx.isHidden)
            .disposed(by: bag)
        
        running
            .drive(iconLabel.rx.isHidden)
            .disposed(by: bag)
        
        running
            .drive(humidityLabel.rx.isHidden)
            .disposed(by: bag)
        
        running
            .drive(cityNameLabel.rx.isHidden)
            .disposed(by: bag)
        
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
        
        let geoSearch = geoLocationButton.rx.tap
            .flatMapLatest { _ in
                self.locationManager.rx.getCurrentLocation()
            }
            .flatMapLatest { location in
                ApiController.shared
                    .currentWeather(at: location.coordinate)
                    .catchErrorJustReturn(.empty)
            }
        
        let textSearch = searchInput.flatMap { city in
            ApiController.shared
                .currentWeather(for: .city)
        }
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

