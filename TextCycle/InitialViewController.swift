//
//  InitialViewController.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/29.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var toSignupFormButton: UIButton!
    @IBOutlet weak var toLoginFormButton: UIButton!
    
    @IBAction func startButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // Navbarを隠す
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
