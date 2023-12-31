//
//  TodoItemCoordinator.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 29.06.2023.
//

import Foundation

@MainActor
protocol TodoItemCoordinator: AnyObject {
    func closeDetails()
}
