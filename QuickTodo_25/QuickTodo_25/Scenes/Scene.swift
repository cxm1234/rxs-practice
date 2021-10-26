//
//  Scenes.swift
//  QuickTodo_25
//
//  Created by  generic on 2021/10/26.
//

import Foundation
import UIKit

enum Scene {
    case tasks(TasksViewModel)
    case editTask(EditTaskViewModel)
}

extension Scene {
    func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch self {
        case .tasks(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "Tasks") as! UINavigationController
            let vc = nc.viewControllers.first as! TasksViewController
//            vc.
            
        }
    }
}
