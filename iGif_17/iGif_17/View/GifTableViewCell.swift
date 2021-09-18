//
//  GifTableViewCell.swift
//  iGif_17
//
//  Created by  generic on 2021/9/18.
//

import UIKit
import RxSwift
import Gifu

class GifTableViewCell: UITableViewCell {
    
    @IBOutlet private var gifImageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    var disposable = SingleAssignmentDisposable()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gifImageView.prepareForReuse()
        gifImageView.image = nil
        disposable.dispose()
        disposable = SingleAssignmentDisposable()
        
    }
    
    func downloadAndDisplay(gif url: URL) {
        let request = URLRequest(url: url)
        activityIndicator.startAnimating()
    }
}

extension UIImageView: GIFAnimatable {
    private struct AssociatedKeys {
        static var AnimatorKey = "gifu.animator.key"
    }
    
    open override func display(_ layer: CALayer) {
        updateImageIfNeeded()
    }
    
    public var animator: Animator? {
        get {
            guard let animator = objc_getAssociatedObject(
                    self,
                    &AssociatedKeys.AnimatorKey) as? Animator else {
                let animator = Animator(withDelegate: self)
                self.animator = animator
                return animator
            }
            return animator
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.AnimatorKey, newValue as Animator?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
