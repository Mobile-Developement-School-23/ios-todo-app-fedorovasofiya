//
//  TodoListCoordinator.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 29.06.2023.
//

import Foundation

@MainActor
protocol TodoListCoordinator: AnyObject {
    func openDetails(of item: TodoItem, itemStateChangedCallback: (() -> Void)?)
    func openCreationOfTodoItem(itemStateChangedCallback: (() -> Void)?)
}
