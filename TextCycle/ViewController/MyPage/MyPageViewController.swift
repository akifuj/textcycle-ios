//
//  MyPageViewController.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/06/01.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let myPageViewModel = MyPageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "マイページ"
        bindViewModel()
        
        setupProfileView()
        tableView.delegate = self
    }
    
    private func bindViewModel() {
        myPageViewModel.myPosts.bind(to: tableView!) { myPosts, indexPath, collectionView in
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "PrivatePost", for: indexPath)
            cell.textLabel?.text = myPosts[indexPath.row].title
            return cell
        }
        
        // indicator
        myPageViewModel.isLoading.bind(to: loadingIndicator.reactive.isAnimating)
        myPageViewModel.isLoading.map { !$0 }.bind(to: loadingIndicator.reactive.isHidden)
    }
    
    private func setupProfileView() {
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        tapGesture.delegate = self
        profileView.addGestureRecognizer(tapGesture)
        if let username = ud.object(forKey: "Username") as? String {
            usernameLabel.text = username
        }
        if let introduction = ud.object(forKey: "Introduction") as? String {
            introductionLabel.text = introduction
        }
    }
    
    func tap(_ sender: UITapGestureRecognizer){
        if !registered.value {
            toSignup(on: self)
        } else if let modifyProfileVC = storyboard?.instantiateViewController(withIdentifier: "ModifyProfileTable") as? ModifyProfileTableViewController{
            modifyProfileVC.modifyProfileViewModel = ModifyProfileViewModel()
            navigationController?.pushViewController(modifyProfileVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let modifyPostVC = storyboard?.instantiateViewController(withIdentifier: "ModifyPostTable") as? ModifyPostTableViewController{
            modifyPostVC.modifyPostViewModel = ModifyPostViewModel(post: myPageViewModel.myPosts[indexPath.row])
            navigationController?.pushViewController(modifyPostVC, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
