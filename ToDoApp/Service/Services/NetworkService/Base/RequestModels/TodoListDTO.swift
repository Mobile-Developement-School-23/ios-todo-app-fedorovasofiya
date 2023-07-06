//
//  TodoListDTO.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 05.07.2023.
//

import Foundation

struct TodoListDTO: Codable {
    let status: String
    let list: [ElementDTO]
    let revision: Int?

    init(status: String = "ok", list: [ElementDTO], revision: Int? = nil) {
        self.status = status
        self.list = list
        self.revision = revision
    }
}
