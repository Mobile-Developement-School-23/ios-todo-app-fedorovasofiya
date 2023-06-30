//
//  TodoListViewOutput.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 29.06.2023.
//

import Foundation

protocol TodoListViewOutput {
    var todoListLoaded: (([TodoItemTableViewCell.DisplayData]) -> ())? { get set }
    var errorOccurred: ((String) -> ())? { get set }
    func loadItems()
    func didTapAdd()
    func deleteItem(at: Int)
    func didSelectItem(at: Int)
    func toggleIsDoneValue(index: Int)
    func toggleIsDoneValue(id: UUID)
}
