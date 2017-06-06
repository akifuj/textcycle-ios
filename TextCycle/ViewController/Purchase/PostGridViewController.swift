//
//  PostGridViewController.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/30.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class PostGridViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBAction func toCategoryButton(_ sender: UIBarButtonItem) {
        if let optionVC = storyboard?.instantiateViewController(withIdentifier: "OptionTable") as? OptionsTableViewController{
            optionVC.option = .Category
            optionVC.postGridViewModel = postGridViewModel
            
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            navigationController!.view.layer.add(transition, forKey:nil)
            navigationController!.pushViewController(optionVC, animated: false)
        }
    }

    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let postGridViewModel = PostGridViewModel()
    let bag = DisposeBag()
    
    var category: Category?
    let searchEmpty = Observable(true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarTextField.delegate = self
        collectionView.delegate = self
        bindViewModel()
    }
    
    // set title
    override func viewWillAppear(_ animated: Bool) {
        if let category = postGridViewModel.category.value {
            self.title = category.name
        } else {
            self.title = "TextCycle"
        }
    }
    
    func bindViewModel() {
        //view
        postGridViewModel.isLoading.map { !$0 }.bind(to: view.reactive.isUserInteractionEnabled)
        
        // searchBar
        postGridViewModel.searchString.bind(to: searchBarTextField.reactive.text)
        
        // collectionviewcell
        postGridViewModel.searchResults.bind(to: collectionView!) { searchResults, indexPath, collectionView in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Post", for: indexPath) as! PostCollectionViewCell
            cell.post = searchResults[indexPath.row]
            return cell
        }
        
        // indicator
        postGridViewModel.isLoading.bind(to: loadingIndicator.reactive.isAnimating)
        postGridViewModel.isLoading.map { !$0 }.bind(to: loadingIndicator.reactive.isHidden)
        
        // alert
        _ = postGridViewModel.alertMessages.observeNext {
            [weak self] message in
            let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self?.present(alertController, animated: true, completion: nil)
            }.dispose(in: bag)
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let searchVC = storyboard?.instantiateViewController(withIdentifier: "SearchTable") as? SearchTableViewController{
            searchVC.postGridViewModel = postGridViewModel
            navigationController?.pushViewController(searchVC, animated: true)
        }
        return true
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/3, height: self.view.frame.width/3);
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width)/3, height: UIScreen.main.bounds.size.height/3+35.0);
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let sinelePostVC = storyboard?.instantiateViewController(withIdentifier: "SinglePost") as? SinglePostTableViewController{
            sinelePostVC.singlePostViewModel = SinglePostViewModel(post: postGridViewModel.searchResults[indexPath.row])
            navigationController?.pushViewController(sinelePostVC, animated: true)
        }
    }
    
    /*
    // scroll to the bottom, load more
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0 {
            postGridViewModel.loadmore()
        }
    }
 */
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
