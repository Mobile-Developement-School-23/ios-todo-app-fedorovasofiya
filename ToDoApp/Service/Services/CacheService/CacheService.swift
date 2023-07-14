//
//  CacheService.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 13.07.2023.
//

import Foundation

protocol CacheService {
    var todoItems: [UUID: TodoItem] { get }
    var isDirty: Bool { get }
    func updateIsDirtyValue(by newValue: Bool)
    func loadTodoList() throws -> [TodoItem]
    func updateTodoList(with todoList: [TodoItem]) async throws
    func insertTodoItem(_ todoItem: TodoItem) async throws
    func updateTodoItem(_ todoItem: TodoItem) async throws
    func deleteTodoItem(with id: UUID) async throws
}
