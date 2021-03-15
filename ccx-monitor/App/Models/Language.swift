//
//  Language.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/1/21.
//

import Foundation

enum Language: String {
    case en
    case de
    case es
    case fr
    case it
    case pl
    case ro
    case hu
    case nl
    case pt
    case sv
    case vi
    case tr
    case ru
    case ja
    case zh
    case zh_tw = "zh-tw"
    case ko
    case ar
    case th
    case id
}

extension Language {
    static let preferred = Bundle.main.preferredLocalizations.first?.prefix(2) ?? "en"
}
