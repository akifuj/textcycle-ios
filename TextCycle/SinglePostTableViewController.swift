//
//  SInglePostTableViewController.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/28.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit
import MessageUI

class SinglePostTableViewController: UITableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var listPriceLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var degreeYearLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBAction func contactButtonAction(_ sender: UIButton) {
        if !registered.value {
            toSignup(on: self)
        } else {
            let alertController = UIAlertController(title: "この出品者に連絡を取りますか？", message: nil, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "はい", style: .default, handler: showMessageVC)
            let noAction = UIAlertAction(title: "いいえ", style: .default) { action in return }
            alertController.addAction(noAction)
            alertController.addAction(yesAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    var singlePostViewModel: SinglePostViewModel!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupLabel()
    }
    
    private func bindViewModel() {
        //view
        singlePostViewModel.isLoading.map { !$0 }.bind(to: view.reactive.isUserInteractionEnabled)
        
        // indicator
        singlePostViewModel.isLoading.bind(to: loadingIndicator.reactive.isAnimating)
        singlePostViewModel.isLoading.map { !$0 }.bind(to: loadingIndicator.reactive.isHidden)
        
        // alert
        _ = singlePostViewModel.alertMessages.observeNext {
            [weak self] message in
            let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self?.present(alertController, animated: true, completion: nil)
            }.dispose(in: bag)
    }
    
    
    private func setupLabel() {
        let post = singlePostViewModel.post
        self.title = post.title
        titleLabel.text = post.title
        authorLabel.text = post.author
        publisherLabel.text = post.publisher
        conditionLabel.text = Condition(rawValue: Int(post.condition))?.name
        listPriceLabel.text = "¥ " + String(post.listPrice)
        priceLabel.text = "¥ " + String(post.price)
        
        _ = singlePostViewModel.user
            .observeNext {
                [weak self] user in
                if let user = user {
                    self?.usernameLabel.text = user.username
                    self?.majorLabel.text = Major(rawValue: Int(user.major))?.name
                    self?.degreeYearLabel.text = (Degree(rawValue: Int(user.degree))?.name)! + String(user.year) + "年"
                    self?.sexLabel.text = Sex(rawValue: Int(user.sex))?.name
                    self?.introductionLabel.text = user.introduction
                }
            }
        
    }
    
    private func showMessageVC(action: UIAlertAction! = nil) {
        if !MFMessageComposeViewController.canSendText() {
            singlePostViewModel.alertMessages.next("この端末ではSMSが使えません")
        } else {
            self.present(singlePostViewModel.setMessageVC(), animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
