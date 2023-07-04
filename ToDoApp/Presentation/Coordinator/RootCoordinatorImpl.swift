//
//  RootCoordinatorImpl.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 29.06.2023.
//

import Foundation
import UIKit

final class RootCoordinatorImpl: RootCoordinator {

    private weak var window: UIWindow?
    private weak var transitioningDelegate: UIViewControllerTransitioningDelegate?
    private lazy var fileCache = FileCacheImpl()
    private lazy var dateService = DateServiceImpl()

    func start(in window: UIWindow) {
        self.window = window
        openTodoList()
    }

    // MARK: - Navigation

    private func openTodoList() {
        let viewModel = TodoListViewModel(fileCache: fileCache, dateService: dateService, coordinator: self)
        let animator = Animator()
        let viewController = TodoListViewController(viewOutput: viewModel, animator: animator)
        transitioningDelegate = viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func openTodoItem(_ item: TodoItem?, itemStateChangedCallback: (() -> Void)?) {
        let viewModel = TodoItemViewModel(
            todoItem: item,
            fileCache: fileCache,
            coordinator: self,
            itemStateChanged: itemStateChangedCallback
        )
        let viewController = TodoItemViewController(viewOutput: viewModel, dateService: dateService)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.transitioningDelegate = transitioningDelegate
        window?.rootViewController?.dismiss(animated: true)
        window?.rootViewController?.present(navigationController, animated: true)
    }

    private func closeTodoItem() {
        window?.rootViewController?.dismiss(animated: true)
    }

}

// MARK: - TodoListCoordinator

extension RootCoordinatorImpl: TodoListCoordinator {

    func openDetails(of item: TodoItem, itemStateChangedCallback: (() -> Void)?) {
        openTodoItem(item, itemStateChangedCallback: itemStateChangedCallback)
    }

    func openCreationOfTodoItem(itemStateChangedCallback: (() -> Void)?) {
        openTodoItem(nil, itemStateChangedCallback: itemStateChangedCallback)
    }

}

// MARK: - TodoItemCoordinator

extension RootCoordinatorImpl: TodoItemCoordinator {

    func closeDetails() {
        closeTodoItem()
    }

}
