//
//  ModifyProfileTableViewController.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/06/01.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class ModifyProfileTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var introductionTextField: UITextField!
    
    @IBOutlet weak var modifyButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var modifyProfileViewModel:ModifyProfileViewModel!
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "プロフィール"
        bindViewModel()
        
        introductionTextField.delegate = self
    }
    
    private func bindViewModel() {
        //view
        modifyProfileViewModel.isLoading.map { !$0 }.bind(to: view.reactive.isUserInteractionEnabled)
        
        // label
        modifyProfileViewModel.username.bind(to: usernameLabel.reactive.text)
        modifyProfileViewModel.degree
            .map { $0.name }
            .bind(to: degreeLabel.reactive.text)
        modifyProfileViewModel.year
            .map { $0.name }
            .bind(to: yearLabel.reactive.text)
        modifyProfileViewModel.sex
            .map { $0.name }
            .bind(to: sexLabel.reactive.text)
        
        // textfield
        modifyProfileViewModel.introduction.bidirectionalBind(to: introductionTextField.reactive.text)
    
        // button
        modifyButton.reactive.tap
            .observe { [weak self] _ -> Void in
                self?.modifyProfileViewModel.modifyUser()
            }.dispose(in: bag)
    
        // indicator
        modifyProfileViewModel.isLoading.bind(to: loadingIndicator.reactive.isAnimating)
        modifyProfileViewModel.isLoading.map { !$0 }.bind(to: loadingIndicator.reactive.isHidden)
        
        // alert
        _ = modifyProfileViewModel.alertMessages.observeNext {
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
                    optionVC.option = .Degree
                    optionVC.modifyProfileViewModel = modifyProfileViewModel
                    navigationController?.pushViewController(optionVC, animated: true)
                }
            case 2:
                if let optionVC = storyboard?.instantiateViewController(withIdentifier: "OptionTable") as? OptionsTableViewController{
                    optionVC.option = .Year
                    optionVC.modifyProfileViewModel = modifyProfileViewModel
                    navigationController?.pushViewController(optionVC, animated: true)
                }
            case 3:
                if let optionVC = storyboard?.instantiateViewController(withIdentifier: "OptionTable") as? OptionsTableViewController{
                    optionVC.option = .Sex
                    optionVC.modifyProfileViewModel = modifyProfileViewModel
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
