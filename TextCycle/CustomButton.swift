//
//  CustomButton.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/06/03.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setTitleColor(UIColor(red: 0, green: 219 / 255.0, blue: 118 / 255.0, alpha: 1), for: .normal)
        self.layer.cornerRadius = 8.0
        self.layer.position = CGPoint(x: self.bounds.width/2
            , y:self.bounds.height/2)
        self.layer.borderColor = UIColor(red: 0, green: 219 / 255.0, blue: 118 / 255.0, alpha: 1).cgColor
        self.layer.borderWidth = 1
    }

}
