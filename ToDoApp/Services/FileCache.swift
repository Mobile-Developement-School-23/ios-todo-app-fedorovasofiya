//
//  FileCache.swift
//  ToDoList
//
//  Created by Sonya Fedorova on 15.06.2023.
//

import Foundation

class FileCache {
    
    private(set) var todoCollection: Dictionary<UUID, TodoItem> = [:]
    
    // MARK: - Public Methods
    
    func addItem(_ item: TodoItem) {
        todoCollection[item.id] = item
    }
    
    func deleteItem(with id: UUID) {
        todoCollection.removeValue(forKey: id)
    }
    
    func saveItems(to jsonFile: String) throws {
        let itemsArray = todoCollection.values.map { item in
            item.json
        }
        let jsonData = try JSONSerialization.data(withJSONObject: itemsArray, options: [.prettyPrinted, .sortedKeys])
        try saveDataToDocuments(jsonData, fileName: jsonFile)
    }
    
    func loadItems(from jsonFile: String) throws {
        let jsonData = try loadDataFromDocuments(fileName: jsonFile)
        let decodedData = try JSONSerialization.jsonObject(with: jsonData, options: [])
        guard
            let itemsArray = decodedData as? [Dictionary<String, Any>]
        else { return }
        
        var newTodoCollection: Dictionary<UUID, TodoItem> = [:]
        itemsArray.forEach { dictionary in
            if let item = TodoItem.parse(json: dictionary) {
                newTodoCollection[item.id] = item
            }
        }
        todoCollection = newTodoCollection
    }
    
    // MARK: - Private Methods
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func saveDataToDocuments(_ data: Data, fileName: String) throws {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        try data.write(to: fileURL)
    }
    
    private func loadDataFromDocuments(fileName: String) throws -> Data {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        return try Data(contentsOf: fileURL)
    }
    
}
