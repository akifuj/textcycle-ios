//
//  SignupTableViewController.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/29.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit
import DigitsKit

class SignupTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var phoneNumberConfirmButton: UIButton!
    @IBOutlet weak var phoneNumberIndicator: UIActivityIndicatorView!
    @IBOutlet weak var introductionTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private var signupViewModel = SignupViewModel()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        
        usernameTextField.delegate = self
        introductionTextField.delegate = self
        
        //Digits.sharedInstance().logOut()
        signupViewModel.checkSignupBefore()
        
    }
    
    private func bindViewModel() {
        //view
        signupViewModel.isDigitsLoading.map { !$0 }.bind(to: view.reactive.isUserInteractionEnabled)
        signupViewModel.isLoading.map { !$0 }.bind(to: view.reactive.isUserInteractionEnabled)
        
        // label
        signupViewModel.major
            .map { $0.name }
            .bind(to: majorLabel.reactive.text)
        signupViewModel.degree
            .map { $0.name }
            .bind(to: degreeLabel.reactive.text)
        signupViewModel.year
            .map { $0.name }
            .bind(to: yearLabel.reactive.text)
        signupViewModel.sex
            .map { $0.name }
            .bind(to: sexLabel.reactive.text)
        
        // textfield
        signupViewModel.username.bidirectionalBind(to: usernameTextField.reactive.text)
        signupViewModel.introduction.bidirectionalBind(to: introductionTextField.reactive.text)
        
        // button
        signupViewModel.phoneNumber
            .map { $0 == "" }
            .bind(to: phoneNumberConfirmButton.reactive.isEnabled)
        signupViewModel.phoneNumber
            .map { $0 == "" }
            .map{ $0 ? CGFloat(1.0) : CGFloat(0.5) }
            .bind(to: phoneNumberConfirmButton.reactive.alpha)
        phoneNumberConfirmButton.reactive.tap
            .observe { [weak self] _ -> Void in
                self?.signupViewModel.confirmPhoneNumber()
            }
            .dispose(in: bag)
        
        signupViewModel.isValid.bind(to: confirmButton.reactive.isEnabled)
        signupViewModel.isValid
            .map{ $0 ? CGFloat(1.0) : CGFloat(0.5) }
            .bind(to: confirmButton.reactive.alpha)
        confirmButton.reactive.tap
            .observe { [weak self] _ -> Void in
                self?.signupViewModel.signup()
            }
            .dispose(in: bag)
        
        // indicator
        signupViewModel.isDigitsLoading.bind(to: phoneNumberIndicator.reactive.isAnimating)
        signupViewModel.isDigitsLoading.map { !$0 }.bind(to: phoneNumberIndicator.reactive.isHidden)
        signupViewModel.isLoading.bind(to: loadingIndicator.reactive.isAnimating)
        signupViewModel.isLoading.map { !$0 }.bind(to: loadingIndicator.reactive.isHidden)
        
        // alert
        _ = signupViewModel.alertMessages.observeNext {
            [weak self] message in
            let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self?.present(alertController, animated: true, completion: nil)
        }
        
        // registered
        registered.filter { $0 }
            .observe { [weak self] _ -> Void in
                self?.dismiss(animated: true, completion: nil)
            }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            switch indexPath.row {
            case 1:
                if let optionVC = storyboard?.instantiateViewController(withIdentifier: "OptionTable") as? OptionsTableViewController{
                    optionVC.option = .Major
                    optionVC.signupViewModel = signupViewModel
                    navigationController?.pushViewController(optionVC, animated: true)
                }
            case 2:
                if let optionVC = storyboard?.instantiateViewController(withIdentifier: "OptionTable") as? OptionsTableViewController{
                    optionVC.option = .Degree
                    optionVC.signupViewModel = signupViewModel
                    navigationController?.pushViewController(optionVC, animated: true)
                }
            case 3:
                if let optionVC = storyboard?.instantiateViewController(withIdentifier: "OptionTable") as? OptionsTableViewController{
                    optionVC.option = .Year
                    optionVC.signupViewModel = signupViewModel
                    navigationController?.pushViewController(optionVC, animated: true)
                }
            case 4:
                if let optionVC = storyboard?.instantiateViewController(withIdentifier: "OptionTable") as? OptionsTableViewController{
                    optionVC.option = .Sex
                    optionVC.signupViewModel = signupViewModel
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


