//
//  MainViewController.swift
//  Combinestagram_04
//
//  Created by xiaoming on 2021/5/25.
//

import UIKit
import RxSwift
import RxRelay

class MainViewController: UIViewController {
    
    private let bag = DisposeBag()
    private let images = BehaviorRelay<[UIImage]>(value: [])

    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var itemAdd: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images
            .subscribe(onNext: { [weak imagePreview] photos in
                guard let preview = imagePreview else { return }
                preview.image = photos.collage(size: preview.frame.size)
            })
            .disposed(by: bag)

    }
    
    @IBAction func actionClear(_ sender: Any) {
        images.accept([])
    }
    
    @IBAction func actionSave(_ sender: Any) {
    }
     
    @IBAction func actionAdd(_ sender: Any) {
        let newImages = images.value + [UIImage(named: "IMG_1907.jpg")!]
        images.accept(newImages)
    }
    
    func showMessage(_ title: String, description: String? = nil) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

}
