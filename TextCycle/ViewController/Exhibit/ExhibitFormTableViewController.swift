//
//  ExhibitFormTableViewController.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/26.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class ExhibitFormTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var listPriceLabel: UILabel!

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var exhibitButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    var exhibitFormViewModel: ExhibitFormViewModel!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "出品する"
        bindViewModel()

        priceTextField.delegate = self
        
    }
    
    private func bindViewModel() {
        //view
        exhibitFormViewModel.isLoading.map { !$0 }.bind(to: view.reactive.isUserInteractionEnabled)
        
        // label
        exhibitFormViewModel.title.bind(to: titleLabel.reactive.text)
        exhibitFormViewModel.author.bind(to: authorLabel.reactive.text)
        exhibitFormViewModel.publisher.bind(to: publisherLabel.reactive.text)
        exhibitFormViewModel.listPrice.map { "¥ " + $0! }.bind(to: listPriceLabel.reactive.text)
        exhibitFormViewModel.category
            .map { $0.name }
            .bind(to: categoryLabel.reactive.text)
        exhibitFormViewModel.condition
            .map { $0.name }
            .bind(to: conditionLabel.reactive.text)
        
        // textfield
        priceTextField.reactive.text
            .filter { $0!.characters.count > 0 && !($0!.contains("¥")) }
            .map { "¥" + $0! }
            .bind(to: priceTextField.reactive.text)
        priceTextField.reactive.text
            .filter { $0! == "¥" }
            .map { _ in "" }
            .bind(to: priceTextField.reactive.text)
        exhibitFormViewModel.price.bidirectionalBind(to: priceTextField.reactive.text)
 
        // button
        exhibitFormViewModel.isValid.bind(to: exhibitButton.reactive.isEnabled)
        exhibitFormViewModel.isValid
            .map{ $0 ? CGFloat(1.0) : CGFloat(0.5) }
            .bind(to: exhibitButton.reactive.alpha)
        exhibitButton.reactive.tap
            .observe { [weak self] _ -> Void in
                if registered.value {
                    self?.exhibitFormViewModel.exhibit()
                } else {
                    toSignup(on: self!)
                }
            }.dispose(in: bag)
    
        // alert
        _ = exhibitFormViewModel.alertMessages.observeNext {
            [weak self] message in
            let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
                self?.navigationController?.popViewController(animated: true) }
            alertController.addAction(okAction)
            self?.present(alertController, animated: true, completion: nil)
        }.dispose(in: bag)
        
        // indicator
        exhibitFormViewModel.isLoading.bind(to: loadingIndicator.reactive.isAnimating)
        exhibitFormViewModel.isLoading.map { !$0 }.bind(to: loadingIndicator.reactive.isHidden)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            switch indexPath.row {
                case 0:
                    if let optionVC = storyboard?.instantiateViewController(withIdentifier: "OptionTable") as? OptionsTableViewController{
                        optionVC.option = .Category
                        optionVC.exhibitFormViewModel = exhibitFormViewModel
                        navigationController?.pushViewController(optionVC, animated: true)
                }
                case 1:
                    if let optionVC = storyboard?.instantiateViewController(withIdentifier: "OptionTable") as? OptionsTableViewController{
                        optionVC.option = .Condition
                        optionVC.exhibitFormViewModel = exhibitFormViewModel
                        navigationController?.pushViewController(optionVC, animated: true)
                }
            default:
                return
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
