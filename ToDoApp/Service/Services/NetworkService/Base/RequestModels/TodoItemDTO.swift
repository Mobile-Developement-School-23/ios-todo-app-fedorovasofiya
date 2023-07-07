//
//  TodoItemDTO.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 05.07.2023.
//

import Foundation

struct TodoItemDTO: Codable {
    let status: String
    let element: ElementDTO
    let revision: Int?

    init(status: String = "ok", element: ElementDTO, revision: Int? = nil) {
        self.status = status
        self.element = element
        self.revision = revision
    }
}
