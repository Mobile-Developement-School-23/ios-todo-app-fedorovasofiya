//
//  RootCoordinator.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 29.06.2023.
//

import Foundation
import UIKit

@MainActor
protocol RootCoordinator: AnyObject {
    func start(in window: UIWindow)
}
