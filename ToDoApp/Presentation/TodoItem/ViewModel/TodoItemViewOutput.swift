//
//  TodoItemViewOutput.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 22.06.2023.
//

import Foundation

protocol TodoItemViewOutput {
    var todoItemLoaded: ((TodoItem) -> Void)? { get set }
    var successfullySaved: (() -> Void)? { get set }
    var successfullyDeleted: (() -> Void)? { get set }
    var errorOccurred: ((String) -> Void)? { get set }
    var itemStateChanged: (() -> Void)? { get set }
    func loadItemIfExist()
    func saveItem(text: String, importance: Importance, deadline: Date?, textColor: String)
    func deleteItem()
    @MainActor func close()
}
