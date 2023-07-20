//
//  AppDelegate.swift
//  ToDoAppSwiftUI
//
//  Created by Sonya Fedorova on 19.07.2023.
//

import Foundation
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UINavigationBar.appearance().layoutMargins.left = 32

        return true
    }
}
