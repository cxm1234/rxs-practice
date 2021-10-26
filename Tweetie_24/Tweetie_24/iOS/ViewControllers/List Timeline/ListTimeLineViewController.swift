//
//  ListTimeLineViewController.swift
//  Tweetie_24
//
//  Created by xiaoming on 2021/10/18.
//

import UIKit
import RxSwift
import Then
import RxRealmDataSources

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
        
        title = "@\(viewModel.list.username)/\(viewModel.list.slug)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: nil, action: nil)
        
        bindUI()
    }
    
    func bindUI() {
        
        navigationItem.rightBarButtonItem!.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigator.show(seque: .listPeople(self.viewModel.account, self.viewModel.list), sender: self)
            })
            .disposed(by: bag)
        
        let dataSource = RxTableViewRealmDataSource<Tweet>(cellIdentifier: "TweetCellView", cellType: TweetCellView.self) { cell, _, tweet in
            cell.update(with: tweet)
        }
        
        viewModel.tweets
            .bind(to: tableView.rx.realmChanges(dataSource))
            .disposed(by: bag)
        
        viewModel.loggedIn
            .drive(messageView.rx.isHidden)
            .disposed(by: bag)
    }

}
