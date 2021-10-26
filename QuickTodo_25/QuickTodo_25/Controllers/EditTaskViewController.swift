//
//  EditTaskViewController.swift
//  QuickTodo_25
//
//  Created by  generic on 2021/10/26.
//

import UIKit

class EditTaskViewController: UIViewController, BindableType {
    
    @IBOutlet var titleView: UITextView!
    @IBOutlet var okButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    var viewModel: EditTaskViewModel!

    func bindViewModel() {
        titleView.text = viewModel.itemTitle
        
        cancelButton.rx.action = viewModel.onCancel
        
        okButton.rx.tap
            .withLatestFrom(titleView.rx.text.orEmpty)
            .bind(to: viewModel.onUpdate.inputs)
            .disposed(by: self.rx.disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleView.becomeFirstResponder()
    }

}
