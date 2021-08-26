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
        
        categories
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        startDownload()
    }
    
    func startDownload() {
        let eoCategories = EONET.categories
        let downloadedEvents = eoCategories.flatMap { categories in
            return Observable.from(categories.map { category in
                EONET.events(forLast: 360, category: category)
            })
        }
        .merge(maxConcurrent: 2)
        let updatedCategories = eoCategories.flatMap { categories in
            downloadedEvents.scan(categories) { updated, events in
                return updated.map { category in
                    let eventsForCategory = EONET.filteredEvents(events: events, forCategory: category)
                    if !eventsForCategory.isEmpty {
                        var cat = category
                        cat.events = cat.events + eventsForCategory
                        return cat
                    }
                    return category
                }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories.value[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        guard !category.events.isEmpty else { return }
        let eventsController = storyboard!.instantiateViewController(withIdentifier: "events") as! EventsViewController
        eventsController.title = category.name
        eventsController.events.accept(category.events)
        navigationController!.pushViewController(eventsController, animated: true)
    }
}

extension CategoriesViewController: UITableViewDelegate {
    
}
