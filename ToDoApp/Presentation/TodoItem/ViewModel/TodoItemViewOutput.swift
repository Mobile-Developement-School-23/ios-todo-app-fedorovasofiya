//
//  TodoItemViewOutput.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 22.06.2023.
//

import Foundation

@MainActor
protocol TodoItemViewOutput {
    var todoItemLoaded: ((TodoItem) -> Void)? { get set }
    var changesSaved: (() -> Void)? { get set }
    var errorOccurred: ((String) -> Void)? { get set }
    func loadItemIfExist()
    func saveItem(text: String, importance: Importance, deadline: Date?, textColor: String)
    func deleteItem()
    func close()
}
