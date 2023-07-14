//
//  SQLiteError.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 14.07.2023.
//

import Foundation

enum SQLiteError: Error {
    case noConnection
    case notFound
}

extension SQLiteError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noConnection:
            return "No database connection"
        case .notFound:
            return "Element not found"
        }
    }
}
