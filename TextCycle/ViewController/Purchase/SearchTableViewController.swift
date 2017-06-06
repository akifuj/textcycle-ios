//
//  SearchTableViewController.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/30.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class SearchTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var searchBarTextField: UITextField!
    
    let searchViewModel = SearchViewModel()
    var postGridViewModel: PostGridViewModel!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "検索する"
        bindViewModel()
        searchBarTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBarTextField.becomeFirstResponder()
        searchBarTextField.clearButtonMode = .whileEditing
    }
    
    private func bindViewModel() {
        //view
        searchViewModel.isLoading.map { !$0 }.bind(to: view.reactive.isUserInteractionEnabled)
        
        // alert
        _ = searchViewModel.errorMessages.observeNext {
            [weak self] message in
            let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { action in return }
            alertController.addAction(okAction)
            self?.present(alertController, animated: true, completion: nil)
        }.dispose(in: bag)
        
        // tableview
        searchViewModel.searchResults.bind(to: tableView) { searchResults, indexPath, tableView in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Candidate", for: indexPath)
            cell.textLabel?.text = searchResults[indexPath.row]
            return cell
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchViewModel.exeuteSearchTitle(with: searchBarTextField.text!)
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postGridViewModel.searchString.value = searchViewModel.searchResults[indexPath.row]
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        bindViewModel()
    }
    
}
