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
    private var imageCache = [Int]()
    
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
        
        images
            .subscribe(onNext: { [weak self] photos in
                self?.updateUI(photos: photos)
            })
            .disposed(by: bag)

    }
    
    private func updateUI(photos: [UIImage]) {
        buttonSave.isEnabled = photos.count > 0 && photos.count % 2 == 0
        buttonClear.isEnabled = photos.count > 0
        itemAdd.isEnabled = photos.count < 6
        title = photos.count > 0 ? "\(photos.count) photos" : "Collageit"
    }
    
    @IBAction func actionClear() {
        images.accept([])
        imageCache = []
    }
    
    @IBAction func actionSave(_ sender: Any) {
        guard let image = imagePreview.image else { return }
        
        PhotoWriter.save(image)
            .subscribe { [weak self] id in
                _ = self?.alert(title: "Saved with id: \(id)", text: nil)
                self?.actionClear()
            } onError: { [weak self] error in
                self?.showMessage("Error", description: error.localizedDescription)
            }.disposed(by: bag)

    }
     
    @IBAction func actionAdd(_ sender: Any) {
        
        let photosViewController = storyboard!.instantiateViewController(identifier: "PhotosViewController") as! PhotosViewController
        
        let newPhotos = photosViewController.selectedPhotos.share()
        
        newPhotos
            .takeWhile({ [weak self] image in
                let count = self?.images.value.count ?? 0
                return count < 6
            })
            .filter({ newImage in
                return newImage.size.width > newImage.size.height
            })
            .filter({ [weak self] newImage in
                let len = newImage.pngData()?.count ?? 0
                guard self?.imageCache.contains(len) == false else {
                    return false
                }
                self?.imageCache.append(len)
                return true
            })
            .subscribe(
                onNext: { [weak self] newImage in
                    guard let images = self?.images else { return }
                    images.accept(images.value + [newImage])
                },
                onDisposed: {
                    print("completed photo selection")
                }
            )
            .disposed(by: bag)
        
        newPhotos
            .ignoreElements()
            .subscribe(onCompleted: { [weak self] in
                self?.updateNavigationIcon()
            })
            .disposed(by: bag)

        navigationController!.pushViewController(photosViewController, animated: true)
    }
    
    private func updateNavigationIcon() {
        let icon = imagePreview.image?
            .scaled(CGSize(width: 22, height: 22))
            .withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: icon, style: .done, target: nil, action: nil)
    }
    
    func showMessage(_ title: String, description: String? = nil) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

}
