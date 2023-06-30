//
//  TodoItemViewOutput.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 22.06.2023.
//

import Foundation

protocol TodoItemViewOutput {
    var todoItemLoaded: ((TodoItem) -> ())? { get set }
    var successfullySaved: (() -> ())? { get set }
    var successfullyDeleted: (() -> ())? { get set }
    var errorOccurred: ((String) -> ())? { get set }
    var itemStateChanged: (() -> ())? { get set }
    func loadItemIfExist()
    func saveItem(text: String, importance: Importance, deadline: Date?, textColor: String)
    func deleteItem()
    func close()
}
