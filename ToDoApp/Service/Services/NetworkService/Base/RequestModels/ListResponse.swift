//
//  ListResponse.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 05.07.2023.
//

import Foundation

struct ListResponse: Codable {
    let status: String
    let list: [Element]
    let revision: Int
}
