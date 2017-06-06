//
//  CustomTable.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/06/03.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import UIKit

class CustomTable: UITableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tableFooterView = UIView()
    }

}
