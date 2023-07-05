//
//  NetworkService.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 05.07.2023.
//

import Foundation

protocol NetworkService {
    func loadTodoList() async throws -> [TodoItem]
}
