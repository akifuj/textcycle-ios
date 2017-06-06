//
//  Options.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/26.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import Foundation

enum Option: Int {
    case Category
    case Condition
    case Major
    case Degree
    case Year
    case Sex
}

enum Category: Int {
    case Commerce
    case Economics
    case Law
    case Social
    case English
    case Language
    case Math
    case Fiction
    case NonFiction
    case Comic
    case Other
    case Count
    
    var name: String! {
        switch self {
        case .Commerce: return "商学部"
        case .Economics: return "経済学部"
        case .Law: return "法学部"
        case .Social: return "社会学"
        case .English: return "英語"
        case .Language: return "英語以外の言語"
        case .Math: return "数学"
        case .Fiction: return "小説・エッセーなど"
        case .NonFiction: return "評論・論説など"
        case .Comic: return "マンガ"
        case .Other: return "その他"
        case .Count: return ""
        }
    }
}

enum Condition: Int {
    case New
    case Better
    case Usual
    case Worse
    case Worst
    case Count
    
    var name: String! {
        switch self {
        case .New: return "新品同様"
        case .Better: return "目立った傷や汚れなし"
        case .Usual: return "やや傷や汚れあり"
        case .Worse: return "傷や汚れあり"
        case .Worst: return "状態が悪い"
        case .Count: return ""
        }
    }
}

enum Major: Int {
    case Commerce
    case Economics
    case Law
    case Social
    case Count
    
    var name: String! {
        switch self {
        case .Commerce: return "商学部"
        case .Economics: return "経済学部"
        case .Law: return "法学部"
        case .Social: return "社会学"
        case .Count: return ""
        }
    }
}

enum Degree: Int {
    case Bachelor
    case Master
    case Doctor
    case Count
    
    var name: String! {
        switch self {
        case .Bachelor: return "学部"
        case .Master: return "修士"
        case .Doctor: return "博士"
        case .Count: return ""
        }
    }
}

enum Year: Int {
    case First
    case Second
    case Third
    case Forth
    case Fifth
    case Count
    
    var name: String! {
        switch self {
        case .First: return "1年生"
        case .Second: return "2年生"
        case .Third: return "3年生"
        case .Forth: return "4年生"
        case .Fifth: return "5年生"
        case .Count: return ""
        }
    }
}


enum Sex: Int {
    case None
    case Male
    case Female
    case Other
    case Count
    
    var name: String! {
        switch self {
        case .None: return ""
        case .Male: return "男性"
        case .Female: return "女性"
        case .Other: return "その他"
        case .Count: return ""
        }
    }
}
