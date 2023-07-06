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
    private lazy var fileCache: FileCache = FileCacheImpl()
    private lazy var dateService: DateService = DateServiceImpl()
    private lazy var networkService: NetworkService = NetworkServiceImpl(
        deviceID: UIDevice.current.identifierForVendor?.uuidString ?? ""
    )

    func start(in window: UIWindow) {
        self.window = window
        openTodoList()
    }

    // MARK: - Navigation

    private func openTodoList() {
        let viewModel = TodoListViewModel(
            networkService: networkService, fileCache: fileCache, dateService: dateService,
            coordinator: self
        )
        let animator = Animator()
        let viewController = TodoListViewController(viewOutput: viewModel, animator: animator)
        transitioningDelegate = viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func openTodoItem(_ item: TodoItem?, dataChangedCallback: (() -> Void)?) {
        let viewModel = TodoItemViewModel(
            todoItem: item,
            fileCache: fileCache,
            networkService: networkService,
            coordinator: self,
            dataChanged: dataChangedCallback
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

    func openDetails(of item: TodoItem, dataChangedCallback: (() -> Void)?) {
        openTodoItem(item, dataChangedCallback: dataChangedCallback)
    }

    func openCreationOfTodoItem(dataChangedCallback: (() -> Void)?) {
        openTodoItem(nil, dataChangedCallback: dataChangedCallback)
    }

}

// MARK: - TodoItemCoordinator

extension RootCoordinatorImpl: TodoItemCoordinator {

    func closeDetails() {
        closeTodoItem()
    }

}
