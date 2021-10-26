//
//  TaskServiceType.swift
//  QuickTodo_25
//
//  Created by  generic on 2021/10/26.
//

import Foundation
import RxSwift
import RealmSwift

enum TaskServiceError: Error {
    case creationFailed
    case updateFailed(TaskItem)
    case deletionFailed(TaskItem)
    case toggleFailed(TaskItem)
}

protocol TaskServiceType {
    
}
