//
//  TodoListCoordinator.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 29.06.2023.
//

import Foundation

protocol TodoListCoordinator: AnyObject {
    func openDetails(of item: TodoItem, itemStateChangedCallback: (() -> ())?)
    func openCreationOfTodoItem(itemStateChangedCallback: (() -> ())?)
}
