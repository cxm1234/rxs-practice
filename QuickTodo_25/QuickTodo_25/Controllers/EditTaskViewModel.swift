//
//  EditTaskViewModel.swift
//  QuickTodo_25
//
//  Created by  generic on 2021/10/26.
//

import Foundation
import RxSwift
import Action

struct EditTaskViewModel {
    
    let itemTitle: String
    let onUpdate: Action<String, Void>!
    let onCancel: CocoaAction!
    let disposeBag = DisposeBag()
    
    init(task: TaskItem, coordinator: SceneCoordinatorType, updateAction: Action<String, Void>, cancelAction: CocoaAction? = nil) {
        itemTitle = task.title
        onUpdate = updateAction
        onCancel = cancelAction
        
        onUpdate.executionObservables
            .take(1)
            .subscribe(onNext: { _ in
                coordinator.pop()
            })
            .disposed(by: disposeBag)
    }
}
