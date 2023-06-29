//
//  TodoItemViewModel.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 22.06.2023.
//

import Foundation

final class TodoItemViewModel: TodoItemViewOutput {
    
    var itemStateChanged: (() -> ())?
    var todoItemLoaded: ((TodoItem) -> ())?
    var successfullySaved: (() -> ())?
    var successfullyDeleted: (() -> ())?
    var errorOccurred: ((String) -> ())?
    
    private let fileCache: FileCache
    private weak var coordinator: TodoItemCoordinator?
    private let cacheFileName = "cache"
    private var todoItem: TodoItem?
    
    init(todoItem: TodoItem?, fileCache: FileCache, coordinator: TodoItemCoordinator, itemStateChanged: (() -> ())?) {
        self.todoItem = todoItem
        self.fileCache = fileCache
        self.coordinator = coordinator
        self.itemStateChanged = itemStateChanged
    }
    
    // MARK: - Public Methods
    
    func loadItemIfExist() {
        if let item = todoItem,
           let todoItemLoaded = todoItemLoaded {
            todoItemLoaded(item)
        }
    }
    
    func saveItem(text: String, importance: Importance, deadline: Date?, textColor: String) {
        updateTodoItem(text: text, importance: importance, deadline: deadline, textColor: textColor)
        
        guard let todoItem = todoItem else { return }
        fileCache.addItem(todoItem)
        do {
            try fileCache.saveItemsToJSON(fileName: cacheFileName)
        } catch {
            if let errorOccurred = errorOccurred {
                errorOccurred(error.localizedDescription)
            }
        }
        
        if let successfullySaved = successfullySaved {
            successfullySaved()
        }
        if let itemStateChanged = itemStateChanged {
            itemStateChanged()
        }
    }
    
    func deleteItem() {
        guard let id = todoItem?.id else { return }
        fileCache.deleteItem(with: id)
        do {
            try fileCache.saveItemsToJSON(fileName: cacheFileName)
        } catch {
            if let errorOccurred = errorOccurred {
                errorOccurred(error.localizedDescription)
            }
        }
        
        if let successfullyDeleted = successfullyDeleted {
            successfullyDeleted()
        }
        if let itemStateChanged = itemStateChanged {
            itemStateChanged()
        }
    }
    
    func close() {
        coordinator?.closeDetails()
    }
    
    // MARK: - Private Methods
    
    private func updateTodoItem(text: String, importance: Importance, deadline: Date?, textColor: String) {
        if let currentTodoItem = todoItem {
            let newItem = TodoItem(
                id: currentTodoItem.id,
                text: text,
                importance: importance,
                deadline: deadline,
                isDone: currentTodoItem.isDone,
                creationDate: currentTodoItem.creationDate,
                modificationDate: currentTodoItem.modificationDate,
                textColor: textColor
            )
            self.todoItem = newItem
        } else {
            self.todoItem = TodoItem(text: text, importance: importance, deadline: deadline, textColor: textColor)
        }
    }
    
}
