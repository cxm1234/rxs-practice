//
//  Storyboard+.swift
//  Tweetie_24
//
//  Created by  generic on 2021/10/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    func instantiateViewController<T>(ofType type: T.Type) -> T {
        return instantiateViewController(withIdentifier: String(describing: type)) as! T
    }
}
