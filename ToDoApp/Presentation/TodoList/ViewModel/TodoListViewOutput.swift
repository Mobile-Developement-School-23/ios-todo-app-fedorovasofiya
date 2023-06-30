//
//  TodoListViewOutput.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 29.06.2023.
//

import Foundation

protocol TodoListViewOutput {
    var completedItemsCountUpdated: ((Int) -> ())? { get set }
    var todoListUpdated: (([TodoItemTableViewCell.DisplayData]) -> ())? { get set }
    var errorOccurred: ((String) -> ())? { get set }
    func loadItems()
    func changedCompletedAreShownValue(newValue: Bool)
    func didTapAdd()
    func deleteItem(with: UUID)
    func didSelectItem(with: UUID)
    func toggleIsDoneValue(for: UUID)
}
