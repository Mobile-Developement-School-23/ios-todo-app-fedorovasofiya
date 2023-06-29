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
    
    private let fileCache: FileCache
    private let dateService: DateService
    private let cacheFileName = "cache"
    private var todoItem: TodoItem?
    
    init(fileCache: FileCache, dateService: DateService) {
        self.fileCache = fileCache
        self.dateService = dateService
    }
    
    // MARK: - Public Methods
    
    func loadItems() {
        do {
            try fileCache.loadItemsFromJSON(fileName: cacheFileName)
            if let todoListLoaded = todoListLoaded {
                let displayData: [TodoItemTableViewCell.DisplayData] = fileCache.todoItems.values.map { item in
                    TodoItemTableViewCell.DisplayData(
                        id: item.id,
                        text: item.text,
                        importance: item.importance,
                        deadline: dateService.getString(from: item.deadline),
                        isDone: item.isDone,
                        textColor: item.textColor
                    )
                }
                todoListLoaded(displayData)
            }
        } catch {
            if let errorOccurred = errorOccurred {
                errorOccurred(error.localizedDescription)
            }
        }
    }
    
}
