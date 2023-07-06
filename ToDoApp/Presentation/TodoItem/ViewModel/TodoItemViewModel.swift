//
//  TodoItemViewModel.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 22.06.2023.
//

import Foundation
import CocoaLumberjackSwift

@MainActor
final class TodoItemViewModel: TodoItemViewOutput {

    var todoItemLoaded: ((TodoItem) -> Void)?
    var changesSaved: (() -> Void)?
    var errorOccurred: ((String) -> Void)?

    private var dataChanged: (() -> Void)?
    private let networkService: NetworkService
    private let fileCache: FileCache
    private weak var coordinator: TodoItemCoordinator?
    private let cacheFileName = "cache"
    private var todoItem: TodoItem?

    init(todoItem: TodoItem?, fileCache: FileCache, networkService: NetworkService, coordinator: TodoItemCoordinator,
         dataChanged: (() -> Void)?) {
        self.todoItem = todoItem
        self.fileCache = fileCache
        self.networkService = networkService
        self.coordinator = coordinator
        self.dataChanged = dataChanged
    }

    // MARK: - Public Methods

    func loadItemIfExist() {
        if let item = todoItem,
           let todoItemLoaded = todoItemLoaded {
            todoItemLoaded(item)
        }
    }

    func saveItem(text: String, importance: Importance, deadline: Date?, textColor: String) {
        let newItem = getTodoItem(text: text, importance: importance, deadline: deadline, textColor: textColor)
        let isNewItem = todoItem == nil ? true : false
        todoItem = newItem
        saveItemToCache(newItem)

        if fileCache.isDirty {
            syncData()
        } else if isNewItem {
            addNewTodoItem(newItem)
        } else {
            updateTodoItem(newItem)
        }
    }

    func deleteItem() {
        guard let id = todoItem?.id else { return }
        deleteItemFromCache(with: id)

        if fileCache.isDirty {
            syncData()
        } else {
            deleteTodoItem(with: id)
        }
    }

    func close() {
        coordinator?.closeDetails()
    }

    // MARK: - Private Methods

    private func getTodoItem(text: String, importance: Importance, deadline: Date?, textColor: String) -> TodoItem {
        if let currentTodoItem = todoItem {
            let newItem = TodoItem(
                id: currentTodoItem.id,
                text: text,
                importance: importance,
                deadline: deadline,
                isDone: currentTodoItem.isDone,
                creationDate: currentTodoItem.creationDate,
                modificationDate: Date(),
                textColor: textColor
            )
            return newItem
        } else {
            return TodoItem(text: text, importance: importance, deadline: deadline, textColor: textColor)
        }
    }

    // MARK: - Networking

    private func addNewTodoItem(_ item: TodoItem) {
        Task(priority: .userInitiated) { [weak self] in
            guard let self = self else { return }
            do {
                try await self.networkService.addTodoItem(item)
                if let changesSaved = self.changesSaved {
                    changesSaved()
                }
            } catch {
                DDLogError(error.localizedDescription)
                self.fileCache.updateIsDirtyValue(by: true)
                if let errorOccurred = self.errorOccurred {
                    errorOccurred(error.localizedDescription)
                }
            }
        }
    }

    private func updateTodoItem(_ item: TodoItem) {
        Task(priority: .userInitiated) { [weak self] in
            guard let self = self else { return }
            do {
                try await self.networkService.changeTodoItem(item)
                if let changesSaved = self.changesSaved {
                    changesSaved()
                }
            } catch {
                DDLogError(error.localizedDescription)
                self.fileCache.updateIsDirtyValue(by: true)
                if let errorOccurred = self.errorOccurred {
                    errorOccurred(error.localizedDescription)
                }
            }
        }
    }

    private func deleteTodoItem(with id: UUID) {
        Task(priority: .userInitiated) { [weak self] in
            guard let self = self else { return }
            do {
                try await self.networkService.deleteTodoItem(id: id.uuidString)
                if let changesSaved = self.changesSaved {
                    changesSaved()
                }
            } catch {
                DDLogError(error.localizedDescription)
                self.fileCache.updateIsDirtyValue(by: true)
                if let errorOccurred = self.errorOccurred {
                    errorOccurred(error.localizedDescription)
                }
            }
        }
    }

    private func syncData() {
        Task(priority: .userInitiated) { [weak self] in
            guard let self = self else { return }
            do {
                let currentTodoList = Array(self.fileCache.todoItems.values)
                let todoList = try await self.networkService.syncTodoList(currentTodoList)
                self.updateCache(with: todoList)
                self.fileCache.updateIsDirtyValue(by: false)
                if let changesSaved = self.changesSaved {
                    changesSaved()
                }
            } catch {
                DDLogError(error.localizedDescription)
                if let errorOccurred = self.errorOccurred {
                    errorOccurred(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Caching

    private func deleteItemFromCache(with id: UUID) {
        fileCache.deleteItem(with: id)
        saveDataToLocalStorage()
        if let dataChanged = dataChanged {
            dataChanged()
        }
    }

    private func saveItemToCache(_ item: TodoItem) {
        fileCache.addItem(item)
        saveDataToLocalStorage()
        if let dataChanged = dataChanged {
            dataChanged()
        }
    }

    private func updateCache(with todoList: [TodoItem]) {
        fileCache.todoItems.keys.forEach(fileCache.deleteItem(with:))
        todoList.forEach(self.fileCache.addItem(_:))
        saveDataToLocalStorage()
        if let dataChanged = dataChanged {
            dataChanged()
        }
    }

    private func saveDataToLocalStorage() {
        Task(priority: .utility) { [weak self] in
            guard let self = self else { return }
            do {
                try await self.fileCache.saveItemsToJSON(fileName: self.cacheFileName)
            } catch {
                DDLogError(error.localizedDescription)
            }
        }
    }

}
