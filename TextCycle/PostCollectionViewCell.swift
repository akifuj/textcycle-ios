//
//  PostCollectionViewCell.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/27.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import UIKit
import Alamofire

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var post: Post! {
        didSet {
            titleLabel.text = String(post.title)
            priceLabel.text = "¥ " + String(post.price)
            Alamofire.request(post.image!).responseData { [unowned self] response in
                if let data = response.result.value {
                    self.bookImage.image = UIImage(data: data)
                }
            }
        }
    }
}
