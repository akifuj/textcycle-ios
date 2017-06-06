//
//  OptionsTableViewController.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/26.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class OptionsTableViewController: UITableViewController {
    
    var option: Option!
    var signupViewModel: SignupViewModel?
    var postGridViewModel: PostGridViewModel?
    var exhibitFormViewModel: ExhibitFormViewModel?
    var modifyProfileViewModel: ModifyProfileViewModel?
    var modifyPostViewModel: ModifyPostViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch option! {
        case .Major:
            return Major.Count.rawValue
        case .Degree:
            return Degree.Count.rawValue
        case .Year:
            return Year.Count.rawValue
        case .Sex:
            return Sex.Count.rawValue
        case .Category:
            if postGridViewModel != nil {
                return Category.Count.rawValue + 1
            } else {
                return Category.Count.rawValue
            }
        case .Condition:
            return Condition.Count.rawValue
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch option! {
        case .Major:
            cell.textLabel!.text = Major(rawValue: indexPath.row)?.name
        case .Degree:
            cell.textLabel!.text = Degree(rawValue: indexPath.row)?.name
        case .Year:
            cell.textLabel!.text = Year(rawValue: indexPath.row)?.name
        case .Sex:
            cell.textLabel!.text = Sex(rawValue: indexPath.row)?.name
        case .Category:
            if postGridViewModel != nil {
                if indexPath.row == 0 {
                    cell.textLabel!.text = "総合"
                } else {
                    cell.textLabel!.text = Category(rawValue: indexPath.row-1)?.name
                }
            } else {
                cell.textLabel!.text = Category(rawValue: indexPath.row)?.name
            }
        case .Condition:
            cell.textLabel?.text = Condition(rawValue: indexPath.row)?.name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch option! {
        case .Major:
            signupViewModel?.major.value = Major(rawValue: indexPath.row)!
        case .Degree:
            if let viewModel = signupViewModel {
                viewModel.degree.value = Degree(rawValue: indexPath.row)!
            } else {
                modifyProfileViewModel?.degree.value = Degree(rawValue: indexPath.row)!
            }
        case .Year:
            if let viewModel = signupViewModel {
                viewModel.year.value = Year(rawValue: indexPath.row)!
            } else {
                modifyProfileViewModel?.year.value = Year(rawValue: indexPath.row)!
            }
        case .Sex:
            if let viewModel = signupViewModel {
                viewModel.sex.value = Sex(rawValue: indexPath.row)!
            } else {
                modifyProfileViewModel?.sex.value = Sex(rawValue: indexPath.row)!
            }
        case .Category:
            if let viewModel = postGridViewModel {
                if indexPath.row == 0 {
                    viewModel.category.value = nil
                } else {
                    viewModel.category.value = Category(rawValue: indexPath.row-1)!
                }
            } else if let viewModel = exhibitFormViewModel {
                viewModel.category.value = Category(rawValue: indexPath.row)!
            } else {
                modifyPostViewModel!.category.value = Category(rawValue: indexPath.row)
            }
        case .Condition:
            if let viewModel = exhibitFormViewModel {
                viewModel.condition.value = Condition(rawValue: indexPath.row)!
            } else {
                modifyPostViewModel!.condition.value = Condition(rawValue: indexPath.row)
            }
        default: break
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

