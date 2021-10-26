//
//  TasksViewController.swift
//  QuickTodo_25
//
//  Created by  generic on 2021/10/26.
//

import UIKit
import RxSwift
import RxDataSources
import Action
import NSObject_Rx

class TasksViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var statisticsLabel: UILabel!
    @IBOutlet var newTasksButton: UIBarButtonItem!
    
    var viewModel: TasksViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
    }
    
    func bindViewModel() {
        
    }

}
