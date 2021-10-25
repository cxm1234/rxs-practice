//
//  PersonTimelineViewController.swift
//  Tweetie_24
//
//  Created by  generic on 2021/10/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Then

class PersonTimelineViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let bag = DisposeBag()
//    private var viewModel: PersonTimelineView

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
