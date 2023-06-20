//
//  AppDelegate.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 16.06.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let todo1 = TodoItem(text: "text1", importance: .regular, deadline: nil, modificationDate: nil)
        let todo2 = TodoItem(text: "text2", importance: .important, deadline: .now + 100, modificationDate: .now + 10)
        let todo3 = TodoItem(text: "text3", importance: .important, deadline: nil, isDone: true, modificationDate: .now)

        let fileCache = FileCache()
        fileCache.addItem(todo1)
        fileCache.addItem(todo2)
        fileCache.addItem(todo3)

        do {
            try fileCache.saveItems(jsonFileName: "test1.json")
            try fileCache.loadItems(jsonFileName: "test1.json")
            print(fileCache.todoItems)

            try fileCache.saveItems(csvFileName: "test1.csv")
            try fileCache.loadItems(csvFileName: "test1.csv")
            print(fileCache.todoItems)
        } catch {
            print(error.localizedDescription)
        }
        fileCache.deleteItem(with: todo1.id)
        fileCache.deleteItem(with: todo2.id)
        print(fileCache.todoItems)

        let todo4 = TodoItem(id: todo3.id, text: "text4", importance: .regular, deadline: nil, modificationDate: nil)
        fileCache.addItem(todo4)
        print(fileCache.todoItems)

        return true
    }

}
