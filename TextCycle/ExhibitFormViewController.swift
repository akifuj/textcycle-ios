//
//  ExhibitFormViewController.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/26.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import UIKit

class ExhibitFormViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var exhibitFormTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { reutnr }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
