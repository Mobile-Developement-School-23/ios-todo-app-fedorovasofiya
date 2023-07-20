//
//  Importance.swift
//  ToDoAppSwiftUI
//
//  Created by Sonya Fedorova on 18.07.2023.
//

import Foundation

enum Importance: String {

    case unimportant = "low"
    case regular = "basic"
    case important

    var index: Int {
        switch self {
        case .unimportant:
            return 0
        case .regular:
            return 1
        case .important:
            return 2
        }
    }

    static func getValue(index: Int) -> Importance {
        switch index {
        case 0:
            return .unimportant
        case 2:
            return .important
        default:
            return .regular
        }
    }

}
