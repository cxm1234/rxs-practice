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
        eoCategories
            .bind(to: categories)
            .disposed(by: disposeBag)
        
        categories
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                }
            })
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
        cell.textLabel?.text = category.name
        cell.detailTextLabel?.text = category.description
        return cell
    }
    
    
}

extension CategoriesViewController: UITableViewDelegate {
    
}
