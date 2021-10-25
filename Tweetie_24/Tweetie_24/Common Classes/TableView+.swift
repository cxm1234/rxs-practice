//
//  TableView+.swift
//  Tweetie_24
//
//  Created by xiaoming on 2021/10/26.
//

import Foundation
import UIKit

extension UITableView {
    func dequeueCell<T>(ofType type: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: T.self)) as! T
    }
}
