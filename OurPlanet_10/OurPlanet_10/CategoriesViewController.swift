//
//  CategoriesViewController.swift
//  OurPlanet_10
//
//  Created by xiaoming on 2021/8/9.
//

import UIKit
import RxSwift
import RxCocoa

class CategoriesViewController: UIViewController {

    let categories = BehaviorRelay<[EOCategory]>(value: [])
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startDownload()
    }
    
    func startDownload() {
        let eoCategories = EONET.categories
        let downloadedEvents = EONET.events(forLast: 360)
        let updatedCategories = Observable.combineLatest(eoCategories, downloadedEvents) { (categories, events) -> [EOCategory] in
            return categories.map { category in
                var cat = category
                cat.events = events.filter {
                    $0.categories.contains(where: { $0.id == category.id })
                }
                return cat
            }
        }
        
        eoCategories
            .concat(updatedCategories)
            .bind(to: categories)
            .disposed(by: disposeBag)
        
    }

}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")!
        let category = categories.value[indexPath.row]
        cell.textLabel?.text = "\(category.name) (\(category.events.count))"
        cell.accessoryType = (category.events.count > 0) ? .disclosureIndicator : .none
        cell.detailTextLabel?.text = category.description
        return cell
    }
    
    
}

extension CategoriesViewController: UITableViewDelegate {
    
}
