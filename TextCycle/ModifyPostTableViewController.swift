//
//  ModifyPostTableViewController.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/06/01.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class ModifyPostTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var modifyButton: UIButton!
    @IBOutlet weak var modifyLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteLoadingIndicator: UIActivityIndicatorView!
    
    var modifyPostViewModel: ModifyPostViewModel!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = modifyPostViewModel.title.value
        bindViewModel()
        
        priceTextField.delegate = self
    }
    
    private func bindViewModel() {
        //view
        modifyPostViewModel.isModifyLoading.map { !$0 }.bind(to: view.reactive.isUserInteractionEnabled)
        modifyPostViewModel.isDeleteLoading.map { !$0 }.bind(to: view.reactive.isUserInteractionEnabled)
        
        // label
        modifyPostViewModel.title.bind(to: titleLabel.reactive.text)
        modifyPostViewModel.category
            .map { $0?.name }
            .bind(to: categoryLabel.reactive.text)
        modifyPostViewModel.condition
            .map { $0?.name }
            .bind(to: conditionLabel.reactive.text)
        
        // textfield
        modifyPostViewModel.price.bidirectionalBind(to: priceTextField.reactive.text)
        priceTextField.reactive.text
            .filter { $0!.characters.count > 0 && !($0!.contains("¥")) }
            .map { "¥" + $0! }
            .bind(to: priceTextField.reactive.text)
        priceTextField.reactive.text
            .filter { $0! == "¥" }
            .map { _ in "" }
            .bind(to: priceTextField.reactive.text)

        // button
        modifyPostViewModel.isModifyValid.bind(to: modifyButton.reactive.isEnabled)
        modifyPostViewModel.isModifyValid
            .map { $0 ? 1.0 : 0.5 }
            .bind(to: modifyButton.reactive.alpha)
        modifyButton.reactive.tap
            .observe { [weak self] _ in
                self?.modifyPostViewModel.modifyPost()
            }.dispose(in: bag)
        
        modifyPostViewModel.isDeleteValid.bind(to: deleteButton.reactive.isEnabled)
        modifyPostViewModel.isDeleteValid
            .map { $0 ? 1.0 : 0.5 }
            .bind(to: deleteButton.reactive.alpha)
        deleteButton.reactive.tap
            .observe { [weak self] _ in
                self?.modifyPostViewModel.deletePost()
            }.dispose(in: bag)
        
        // indicator
        modifyPostViewModel.isModifyLoading.bind(to: modifyLoadingIndicator.reactive.isAnimating)
        modifyPostViewModel.isModifyLoading.map { !$0 }.bind(to: modifyLoadingIndicator.reactive.isHidden)
        modifyPostViewModel.isDeleteLoading.bind(to: deleteLoadingIndicator.reactive.isAnimating)
        modifyPostViewModel.isDeleteLoading.map { !$0 }.bind(to: deleteLoadingIndicator.reactive.isHidden)

        // alert
        _ = modifyPostViewModel.alertMessages.observeNext {
            [weak self] message in
            let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { action in return }
            alertController.addAction(okAction)
            self?.present(alertController, animated: true, completion: nil)
        }.dispose(in: bag)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            switch indexPath.row {
            case 1:
                if let optionVC = storyboard?.instantiateViewController(withIdentifier: "OptionTable") as? OptionsTableViewController{
                    optionVC.option = .Category
                    optionVC.modifyPostViewModel = modifyPostViewModel
                    navigationController?.pushViewController(optionVC, animated: true)
                }
            case 2:
                if let optionVC = storyboard?.instantiateViewController(withIdentifier: "OptionTable") as? OptionsTableViewController{
                    optionVC.option = .Condition
                    optionVC.modifyPostViewModel = modifyPostViewModel
                    navigationController?.pushViewController(optionVC, animated: true)
                }
            default:
                return
            }
        }
    }
    
    // TextFieldのfocusが外される
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
