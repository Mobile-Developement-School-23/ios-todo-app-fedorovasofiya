//
//  TodoListViewModel.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 29.06.2023.
//

import Foundation

final class TodoListViewModel: TodoListViewOutput {
    
    var todoListLoaded: (([TodoItemTableViewCell.DisplayData]) -> ())?
    var errorOccurred: ((String) -> ())?
    
    private var todoList: [TodoItem] = []
    private let fileCache: FileCache
    private let dateService: DateService
    private weak var coordinator: TodoListCoordinator?
    private let cacheFileName = "cache"
    private lazy var itemStateChangedCallback: (() -> ())? = { [weak self] in
        self?.loadItems
    }()
    
    init(fileCache: FileCache, dateService: DateService, coordinator: TodoListCoordinator) {
        self.fileCache = fileCache
        self.dateService = dateService
        self.coordinator = coordinator
    }
    
    // MARK: - Public Methods
    
    func loadItems() {
        do {
            try fileCache.loadItemsFromJSON(fileName: cacheFileName)
            getData()
        } catch {
            if let errorOccurred = errorOccurred {
                errorOccurred(error.localizedDescription)
            }
        }
    }
    
    func toggleIsDoneValue(for index: Int) {
        guard todoList.indices.contains(index) else { return }
        let item = todoList[index]
        let newIsDoneValue = item.isDone ? false : true
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
        getData()
    }
    
    func deleteItem(at index: Int) {
        guard todoList.indices.contains(index) else { return }
        let id = todoList[index].id
        fileCache.deleteItem(with: id)
        saveChanges()
        loadItems()
    }
    
    func didSelectItem(at index: Int) {
        guard todoList.indices.contains(index) else { return }
        coordinator?.openDetails(of: todoList[index], itemStateChangedCallback: itemStateChangedCallback)
    }
    
    func didTapAdd() {
        coordinator?.openCreationOfTodoItem(itemStateChangedCallback: itemStateChangedCallback)
    }
    
    // MARK: - Private Methods
    
    private func saveChanges() {
        do {
            try fileCache.saveItemsToJSON(fileName: cacheFileName)
        } catch {
            if let errorOccurred = errorOccurred {
                errorOccurred(error.localizedDescription)
            }
        }
    }
    
    private func getData() {
        todoList = Array(fileCache.todoItems.values)
        todoList.sort(by: { $0.creationDate > $1.creationDate })
        
        if let todoListLoaded = todoListLoaded {
            let displayData: [TodoItemTableViewCell.DisplayData] = mapData()
            todoListLoaded(displayData)
        }
    }
    
    private func mapData() -> [TodoItemTableViewCell.DisplayData] {
        todoList.map { item in
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
