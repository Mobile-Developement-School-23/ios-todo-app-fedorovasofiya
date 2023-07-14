//
//  TodoItemViewModelDelegate.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 07.07.2023.
//

import Foundation

@MainActor
protocol TodoItemViewModelDelegate: AnyObject {
    func saveToCacheTodoItem(_ newItem: TodoItem, isNewItem: Bool)
    func deleteFromCacheTodoItem(with id: UUID)
    func saveToServerTodoItem(_ newItem: TodoItem, isNewItem: Bool)
    func deleteFromServerTodoItem(with id: UUID)
}
