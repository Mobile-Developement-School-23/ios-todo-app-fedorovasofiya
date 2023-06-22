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
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
    }
    
    // MARK: - Public Methods
    
    func loadItem() {
        do {
            try fileCache.loadItemsFromJSON(fileName: cacheFileName)
            if let todoItem = fileCache.todoItems.values.first,
               let todoItemLoaded = todoItemLoaded {
                todoItemLoaded(todoItem)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
