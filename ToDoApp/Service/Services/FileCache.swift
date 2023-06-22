//
//  FileCache.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 22.06.2023.
//

import Foundation

protocol FileCache {
    var todoItems: [UUID: TodoItem] { get }
    func addItem(_ item: TodoItem)
    func deleteItem(with id: UUID)
    func saveItemsToJSON(fileName: String) throws
    func loadItemsFromJSON(fileName: String) throws
    func saveItemsToCSV(fileName: String) throws
    func loadItemsFromCSV(fileName: String) throws
}
