//
//  TodoListViewModel.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 29.06.2023.
//

import Foundation
import CocoaLumberjackSwift

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
        self?.loadItems
    }()

    private let fileCache: FileCache
    private let dateService: DateService
    private weak var coordinator: TodoListCoordinator?

    init(fileCache: FileCache, dateService: DateService, coordinator: TodoListCoordinator) {
        self.fileCache = fileCache
        self.dateService = dateService
        self.coordinator = coordinator
    }

    // MARK: - Public Methods

    func loadItems() {
        do {
            try fileCache.loadItemsFromJSON(fileName: cacheFileName)
            updateDataFromFileCache()
            sendData()
        } catch {
            DDLogError(error)
            if let errorOccurred = errorOccurred {
                errorOccurred(error.localizedDescription)
            }
        }
    }

    func changedCompletedAreShownValue(newValue: Bool) {
        completedAreShown = newValue
        sendData()
    }

    func toggleIsDoneValue(for id: UUID) {
        guard let item = fileCache.todoItems[id] else { return }
        let newIsDoneValue = item.isDone ? false : true
        changeIsDoneValue(for: item, newIsDoneValue: newIsDoneValue)
        DDLogInfo("For item with id \(item.id) changed isDoneValue: \(newIsDoneValue)")
        updateDataFromFileCache()
        sendData()
    }

    func deleteItem(with id: UUID) {
        guard let item = fileCache.todoItems[id] else { return }
        fileCache.deleteItem(with: item.id)
        DDLogInfo("Item with id \(item.id) was deleted")
        saveChanges()
        updateDataFromFileCache()
        sendData()
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

    private func updateDataFromFileCache() {
        todoList = Array(fileCache.todoItems.values)
        todoList.sort(by: { $0.creationDate > $1.creationDate })
        completedItemsCount = todoList.filter({ $0.isDone == true }).count
    }

    private func changeIsDoneValue(for item: TodoItem, newIsDoneValue: Bool) {
        let newItem = TodoItem(
            id: item.id,
            text: item.text,
            importance: item.importance,
            deadline: item.deadline,
            isDone: newIsDoneValue,
            creationDate: item.creationDate,
            modificationDate: item.modificationDate,
            textColor: item.textColor
        )
        fileCache.addItem(newItem)
        saveChanges()
    }

    private func saveChanges() {
        do {
            try fileCache.saveItemsToJSON(fileName: cacheFileName)
        } catch {
            DDLogError(error)
            if let errorOccurred = errorOccurred {
                errorOccurred(error.localizedDescription)
            }
        }
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

}
