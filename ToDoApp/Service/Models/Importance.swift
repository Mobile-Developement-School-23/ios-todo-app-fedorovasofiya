//
//  Importance.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 22.06.2023.
//

import Foundation

enum Importance: String {

    case unimportant
    case regular
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
