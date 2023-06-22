//
//  TodoItemViewOutput.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 22.06.2023.
//

import Foundation

protocol TodoItemViewOutput {
    var todoItemLoaded: ((TodoItem) -> ())? { get set }
    func loadItem()
}
