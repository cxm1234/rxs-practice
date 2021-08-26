//
//  EventsViewController.swift
//  OurPlanet_10
//
//  Created by xiaoming on 2021/8/11.
//

import UIKit
import RxSwift
import RxCocoa

class EventsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var daysLabel: UILabel!
    
    let events = BehaviorRelay<[EOEvent]>(value: [])
    let disposeBag = DisposeBag()
    
    let days = BehaviorRelay<Int>(value: 360)
    let filteredEvents = BehaviorRelay<[EOEvent]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        slider.value = Float(days.value)
        
        Observable.combineLatest(days, events) { days, events -> [EOEvent] in
            let maxInterval = TimeInterval(days * 24 * 3600)
            return events.filter { event in
                if let date = event.date {
                    return abs(date.timeIntervalSinceNow) < maxInterval
                }
                return true
            }
        }
        .bind(to: filteredEvents)
        .disposed(by: disposeBag)
        
        filteredEvents.asObservable()
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        days.asObservable()
            .subscribe(onNext: { [weak self] days in
                self?.daysLabel.text = "Last \(days) days"
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        days.accept(Int(sender.value))
    }

}

extension EventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventCell
        let event = filteredEvents.value[indexPath.row]
        cell.configure(event: event)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.value.count
    }
    
    
}

extension EventsViewController: UITableViewDelegate {
    
}
