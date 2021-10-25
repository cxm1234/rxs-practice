//
//  ListTimeLineViewController.swift
//  Tweetie_24
//
//  Created by xiaoming on 2021/10/18.
//

import UIKit
import RxSwift
import Then

class ListTimeLineViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageView: UIView!
    
    private let bag = DisposeBag()
    fileprivate var viewModel: ListTimeLineViewModel!
    fileprivate var navigator: Navigator!
    
    static func createWith(navigator: Navigator,
                           storyboard: UIStoryboard,
                           viewModel: ListTimeLineViewModel) ->
    ListTimeLineViewController {
        return storyboard.instantiateViewController(ofType: ListTimeLineViewController.self).then { vc in
            vc.navigator = navigator
            vc.viewModel = viewModel
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    func bindUI() {
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
