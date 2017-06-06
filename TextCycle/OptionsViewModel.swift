//
//  OptionsViewModel.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/26.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import Foundation
import UIKit

struct OptionsViewModel {
    
    let option: Option
    
    init(option: Option) {
        self.option = option
    }
    
    func numberOfRows() -> Int {
        switch option {
        case .Category:
            return Category.Count.rawValue
        case .Condition:
            return Condition.Count.rawValue
        default:
            return 0
        }
    }
    
    func cellForRowAtIndexPath(index: Int) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch option {
        case .Category:
            cell.textLabel?.text = Category(rawValue: index)?.name
        case .Condition:
            cell.textLabel?.text = Condition(rawValue: index)?.name
        default: break
        }
        return cell
    }
}
