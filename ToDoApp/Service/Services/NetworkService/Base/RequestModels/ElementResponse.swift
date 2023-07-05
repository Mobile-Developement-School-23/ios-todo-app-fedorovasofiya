//
//  ElementResponse.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 05.07.2023.
//

import Foundation

struct ElementResponse: Codable {
    let status: String
    let element: Element
    let revision: Int
}
