//
//  TodoItemViewModel.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 22.06.2023.
//

import Foundation

final class TodoItemViewModel: TodoItemViewOutput {
    
    var todoItemLoaded: ((TodoItem) -> ())?
    
    private let fileCache: FileCache
    private let cacheFileName = "cache"
    private var todoItem: TodoItem?
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
    }
    
    // MARK: - Public Methods
    
    func loadItem() {
        do {
            try fileCache.loadItemsFromJSON(fileName: cacheFileName)
        } catch {
            print(error.localizedDescription)
        }
        if let newItem = fileCache.todoItems.values.first,
           let todoItemLoaded = todoItemLoaded {
            todoItem = newItem
            todoItemLoaded(newItem)
        }
    }
    
    func saveItem(text: String?, importance: Importance, deadline: Date?) {
        guard let text = text else {
            return
        }
        guard let todoItem = todoItem else { return }
        let newItem = TodoItem(
            id: todoItem.id,
            text: text,
            importance: importance,
            deadline: deadline,
            isDone: todoItem.isDone,
            creationDate: todoItem.creationDate,
            modificationDate: todoItem.modificationDate
        )
        self.todoItem = newItem
        fileCache.addItem(newItem)
        do {
            try fileCache.saveItemsToJSON(fileName: cacheFileName)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
