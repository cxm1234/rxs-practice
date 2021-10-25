//
//  ListPeopleViewController.swift
//  Tweetie_24
//
//  Created by  generic on 2021/10/25.
//

import UIKit
import RxSwift
import Then

class ListPeopleViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageView: UIView!
    
    private let bag = DisposeBag()
    fileprivate var viewModel: ListPeopleViewModel!
    fileprivate var navigator: Navigator!
    
    static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: ListPeopleViewModel) -> ListPeopleViewController {
        
        return storyboard.instantiateViewController(ofType: ListPeopleViewController.self).then { vc in
            vc.navigator = navigator
            vc.viewModel = viewModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List Members"
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        
        // Do any additional setup after loading the view.
    }
    
    func bindUI() {
        viewModel.people.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: bag)
    }

}

extension ListPeopleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.people.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueCell(ofType: UserCellView.self).then { cell in
            cell.update(with: viewModel.people.value![indexPath.row])
        }
    }
}

extension ListPeopleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let tweet = viewModel.people.value?[indexPath.row] else { return }
        navigator.show(seque:
                            .personTimeline(
            viewModel.account,
            username: tweet.username
                            ),
                       sender: self
        )
    }
}
