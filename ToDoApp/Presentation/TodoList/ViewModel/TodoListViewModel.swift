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
    private lazy var itemStateChangedCallback: (() -> Void)? = { [weak self] in
        self?.loadTodoList // TODO
    }()

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
        loadDataFromCache()
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
        fileCache.addItem(newItem)
        updateData(with: Array(fileCache.todoItems.values))
        sendData()
        saveDataToCache()
    }

    func deleteItem(with id: UUID) {
        guard let item = fileCache.todoItems[id] else { return }
        fileCache.deleteItem(with: item.id)
        updateData(with: Array(fileCache.todoItems.values))
        sendData()
        saveDataToCache()
    }

    func didSelectItem(with id: UUID) {
        guard let item = fileCache.todoItems[id] else { return }
        coordinator?.openDetails(of: item, itemStateChangedCallback: itemStateChangedCallback)
    }

    func didTapAdd() {
        coordinator?.openCreationOfTodoItem(itemStateChangedCallback: itemStateChangedCallback)
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
            modificationDate: item.modificationDate,
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

    private func loadTodoList() {
        Task(priority: .userInitiated) { [weak self] in
            guard let self = self else { return }
            do {
                let todoList = try await self.networkService.loadTodoList()
                self.updateData(with: todoList)
                self.sendData()
                self.updateCache()
            } catch {
                if let errorOccurred = errorOccurred {
                    errorOccurred(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Caching

    private func updateCache() {
        fileCache.todoItems.keys.forEach(fileCache.deleteItem(with:))
        todoList.forEach(self.fileCache.addItem(_:))
        saveDataToCache()
    }

    private func saveDataToCache() {
        do {
            try fileCache.saveItemsToJSON(fileName: cacheFileName)
        } catch {
            DDLogError(error.localizedDescription)
        }
    }

    private func loadDataFromCache() {
        do {
            try fileCache.loadItemsFromJSON(fileName: cacheFileName)
            updateData(with: Array(fileCache.todoItems.values))
        } catch {
            DDLogError(error.localizedDescription)
        }
    }

}
