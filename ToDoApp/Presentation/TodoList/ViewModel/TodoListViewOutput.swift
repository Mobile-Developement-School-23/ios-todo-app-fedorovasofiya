//
//  TodoListViewOutput.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 29.06.2023.
//

import Foundation

protocol TodoListViewOutput {
    var completedItemsCountUpdated: ((Int) -> Void)? { get set }
    var todoListUpdated: (([TodoItemTableViewCell.DisplayData]) -> Void)? { get set }
    var errorOccurred: ((String) -> Void)? { get set }
    func loadItems()
    func changedCompletedAreShownValue(newValue: Bool)
    func didTapAdd()
    func deleteItem(with: UUID)
    func didSelectItem(with: UUID)
    func toggleIsDoneValue(for: UUID)
}
