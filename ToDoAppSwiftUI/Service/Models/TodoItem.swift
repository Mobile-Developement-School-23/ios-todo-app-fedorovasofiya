//
//  TodoItem.swift
//  ToDoAppSwiftUI
//
//  Created by Sonya Fedorova on 18.07.2023.
//

import Foundation

struct TodoItem: Identifiable {

    let id: UUID
    let text: String
    let importance: Importance
    let deadline: Date?
    var isDone: Bool
    let creationDate: Date
    let modificationDate: Date?

    init(
        id: UUID = UUID(),
        text: String,
        importance: Importance,
        deadline: Date?,
        isDone: Bool = false,
        creationDate: Date = Date(),
        modificationDate: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }

}
