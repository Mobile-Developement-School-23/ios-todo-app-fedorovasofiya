//
//  TodoListViewModel.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 29.06.2023.
//

import Foundation
import CocoaLumberjackSwift

@MainActor
final class TodoListViewModel: TodoListViewOutput {

    var completedItemsCountUpdated: ((Int) -> Void)?
    var todoListUpdated: (([TodoItemTableViewCell.DisplayData]) -> Void)?
    var errorOccurred: ((String) -> Void)?

    // MARK: - Private Properties

    private var completedAreShown: Bool = false
    private var completedItemsCount: Int = 0
    private var todoList: [TodoItem] = []

    private lazy var cacheFileName = "cache"
    private lazy var dataChangedCallback: (() -> Void)? = { [weak self] in
        guard let self = self else { return }
        self.updateData(with: Array(self.fileCache.todoItems.values))
        self.sendData()
    }

    private let networkService: NetworkService
    private let fileCache: FileCache
    private let dateService: DateService
    private weak var coordinator: TodoListCoordinator?

    init(
        networkService: NetworkService,
        fileCache: FileCache,
        dateService: DateService,
        coordinator: TodoListCoordinator
    ) {
        self.networkService = networkService
        self.fileCache = fileCache
        self.dateService = dateService
        self.coordinator = coordinator
        loadDataFromLocalStorage()
    }

    // MARK: - Public Methods

    func viewDidLoad() {
        sendData()
        loadTodoList()
    }

    func changedCompletedAreShownValue(newValue: Bool) {
        completedAreShown = newValue
        sendData()
    }

    func toggleIsDoneValue(for id: UUID) {
        guard let item = fileCache.todoItems[id] else { return }
        let newItem = getUpdatedItem(for: item, newIsDoneValue: item.isDone ? false : true)
        updateItemInCache(newItem)
        sendData()
        saveDataToLocalStorage()

        if fileCache.isDirty {
            syncTodoList()
        } else {
            changeTodoItem(newItem)
        }
    }

    func deleteItem(with id: UUID) {
        deleteFromCacheItem(with: id)
        sendData()
        saveDataToLocalStorage()

        if fileCache.isDirty {
            syncTodoList()
        } else {
            deleteTodoItem(with: id)
        }
    }

    func didSelectItem(with id: UUID) {
        guard let item = fileCache.todoItems[id] else { return }
        coordinator?.openDetails(of: item, dataChangedCallback: dataChangedCallback)
    }

    func didTapAdd() {
        coordinator?.openCreationOfTodoItem(dataChangedCallback: dataChangedCallback)
    }

    // MARK: - Private Methods

    private func sendData() {
        var itemsToDisplay: [TodoItem] = []
        if completedAreShown {
            itemsToDisplay = todoList
        } else {
            itemsToDisplay = todoList.filter({ $0.isDone == false })
        }
        if let todoListLoaded = todoListUpdated {
            let displayData: [TodoItemTableViewCell.DisplayData] = mapData(items: itemsToDisplay)
            todoListLoaded(displayData)
        }
        if let completedItemsCountChanged = completedItemsCountUpdated {
            completedItemsCountChanged(completedItemsCount)
        }
    }

    private func updateData(with newList: [TodoItem]) {
        todoList = newList
        todoList.sort(by: { $0.creationDate > $1.creationDate })
        completedItemsCount = todoList.filter({ $0.isDone == true }).count
    }

    private func getUpdatedItem(for item: TodoItem, newIsDoneValue: Bool) -> TodoItem {
        TodoItem(
            id: item.id,
            text: item.text,
            importance: item.importance,
            deadline: item.deadline,
            isDone: newIsDoneValue,
            creationDate: item.creationDate,
            modificationDate: Date(),
            textColor: item.textColor
        )
    }

    private func mapData(items: [TodoItem]) -> [TodoItemTableViewCell.DisplayData] {
        items.map { item in
            TodoItemTableViewCell.DisplayData(
                id: item.id,
                text: item.text,
                importance: item.importance,
                deadline: dateService.getString(from: item.deadline),
                isDone: item.isDone
            )
        }
    }

    // MARK: - Networking

    private func syncTodoList() {
        Task(priority: .userInitiated) { [weak self] in
            guard let self = self else { return }
            do {
                let todoList = try await self.networkService.syncTodoList(todoList)
                self.updateCache(with: todoList)
                self.sendData()
                self.saveDataToLocalStorage()
                fileCache.updateIsDirtyValue(by: false)
            } catch {
                DDLogError(error.localizedDescription)
                if let errorOccurred = errorOccurred {
                    errorOccurred(error.localizedDescription)
                }
            }
        }
    }

    private func loadTodoList() {
        Task(priority: .userInitiated) { [weak self] in
            guard let self = self else { return }
            do {
                let todoList = try await self.networkService.loadTodoList()
                self.updateCache(with: todoList)
                self.sendData()
                self.saveDataToLocalStorage()
            } catch {
                DDLogError(error.localizedDescription)
                fileCache.updateIsDirtyValue(by: true)
                if let errorOccurred = errorOccurred {
                    errorOccurred(error.localizedDescription)
                }
            }
        }
    }

    private func changeTodoItem(_ item: TodoItem) {
        Task(priority: .userInitiated) { [weak self] in
            guard let self = self else { return }
            do {
                try await self.networkService.changeTodoItem(item)
            } catch {
                DDLogError(error.localizedDescription)
                fileCache.updateIsDirtyValue(by: true)
                if let errorOccurred = errorOccurred {
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
            } catch {
                DDLogError(error.localizedDescription)
                fileCache.updateIsDirtyValue(by: true)
                if let errorOccurred = errorOccurred {
                    errorOccurred(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Caching

    private func updateItemInCache(_ item: TodoItem) {
        fileCache.addItem(item)
        updateData(with: Array(fileCache.todoItems.values))
    }

    private func deleteFromCacheItem(with id: UUID) {
        fileCache.deleteItem(with: id)
        updateData(with: Array(fileCache.todoItems.values))
    }

    private func updateCache(with todoList: [TodoItem]) {
        fileCache.todoItems.keys.forEach(fileCache.deleteItem(with:))
        todoList.forEach(self.fileCache.addItem(_:))
        updateData(with: todoList)
    }

    private func saveDataToLocalStorage() {
        do {
            try fileCache.saveItemsToJSON(fileName: cacheFileName)
        } catch {
            DDLogError(error.localizedDescription)
        }
    }

    private func loadDataFromLocalStorage() {
        do {
            try fileCache.loadItemsFromJSON(fileName: cacheFileName)
            updateData(with: Array(fileCache.todoItems.values))
        } catch {
            DDLogError(error.localizedDescription)
        }
    }

}
