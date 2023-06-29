//
//  AppDelegate.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 16.06.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let viewModel = TodoListViewModel(fileCache: FileCacheImpl(), dateService: DateServiceImpl())
        let viewController = TodoListViewController(viewOutput: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        window = UIWindow()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }

}
