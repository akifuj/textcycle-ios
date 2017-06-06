//
//  LoginViewController.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/24.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private var loginViewModel = LoginViewModel()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        
        phoneNumberTextField.delegate = self
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapSingle(sender:)))
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
    }
    
    private func bindViewModel() {
        //view
        loginViewModel.isLoading.map { !$0 }.bind(to: view.reactive.isUserInteractionEnabled)
        
        // textfield
        phoneNumberTextField.reactive.text.bind(to: loginViewModel.phoneNumber)
        
        // button
        loginViewModel.isValid.bind(to: confirmButton.reactive.isEnabled)
        loginViewModel.isValid
            .map{ $0 ? CGFloat(1.0) : CGFloat(0.5) }
            .bind(to: confirmButton.reactive.alpha)
        confirmButton.reactive.tap
            .observe { [weak self] _ -> Void in
                self?.loginViewModel.login()
            }
            .dispose(in: bag)
        
        // indicator
        loginViewModel.isLoading.bind(to: loadingIndicator.reactive.isAnimating)
        loginViewModel.isLoading.map { !$0 }.bind(to: loadingIndicator.reactive.isHidden)
        
        // alert
        _ = loginViewModel.alertMessages.observeNext {
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
    
    // TextFieldのfocusが外される
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func tapSingle(sender: UITapGestureRecognizer) {
        phoneNumberTextField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
