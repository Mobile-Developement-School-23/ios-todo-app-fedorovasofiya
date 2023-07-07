//
//  FileCache.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 22.06.2023.
//

import Foundation

protocol FileCache {
    var todoItems: [UUID: TodoItem] { get }
    var isDirty: Bool { get }
    func updateIsDirtyValue(by newValue: Bool)
    func addItem(_ item: TodoItem)
    func deleteItem(with id: UUID)
    func saveItemsToJSON(fileName: String) async throws
    func loadItemsFromJSON(fileName: String) async throws
    func saveItemsToCSV(fileName: String) async throws
    func loadItemsFromCSV(fileName: String) async throws
}
