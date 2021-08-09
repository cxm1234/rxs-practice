//
//  CategoriesViewController.swift
//  OurPlanet_10
//
//  Created by xiaoming on 2021/8/9.
//

import UIKit
import RxSwift

class CategoriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func startDownload() {
        
    }

}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")!
        return cell
    }
    
    
}

extension CategoriesViewController: UITableViewDelegate {
    
}
