//
//  SceneCoordinatorType.swift
//  QuickTodo_25
//
//  Created by  generic on 2021/10/26.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType {
    
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitonType) -> Completable
    
    @discardableResult
    func pop(animated: Bool) -> Completable
}

extension SceneCoordinatorType {
    @discardableResult
    func pop() -> Completable {
        return pop(animated: true)
    }
}
