//
//  TodoItem.swift
//  ToDoList
//
//  Created by Sonya Fedorova on 15.06.2023.
//

import Foundation

struct TodoItem: Hashable {
    
    enum Importance: String {
        case unimportant = "неважная"
        case regular = "обычная"
        case important = "важная"
    }
    
    let id: UUID
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let creationDate: Date
    let modificationDate: Date?
    
    init(
        id: UUID = UUID(),
        text: String,
        importance: Importance,
        deadline: Date?,
        isDone: Bool = false,
        creationDate: Date = .now,
        modificationDate: Date?
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }
    
}

// MARK: - JSON Parsing

extension TodoItem {
    
    var json: Any {
        var dictionary: [String : Any] = [:]
        dictionary["id"] = id.uuidString
        dictionary["text"] = text
        if importance != .regular {
            dictionary["importance"] = importance.rawValue
        }
        dictionary["deadline"] = deadline?.timeIntervalSince1970
        dictionary["isDone"] = isDone
        dictionary["creationDate"] = creationDate.timeIntervalSince1970
        dictionary["modificationDate"] = modificationDate?.timeIntervalSince1970
        return dictionary
    }
    
    static func parse(json: Any) -> TodoItem? {
        guard
            let dictionary = json as? [String : Any],
            let idString = dictionary["id"] as? String,
            let id = UUID(uuidString: idString),
            let text = dictionary["text"] as? String,
            let importance = Importance(rawValue: dictionary["importance"] as? String ?? "обычная"),
            let isDone = dictionary["isDone"] as? Bool,
            let creationDateTimeInterval = dictionary["creationDate"] as? TimeInterval
        else { return nil }
        
        let creationDate = Date(timeIntervalSince1970: creationDateTimeInterval)
        
        var deadline: Date? {
            if let deadlineTimeInterval = dictionary["deadline"] as? TimeInterval {
                return Date(timeIntervalSince1970: deadlineTimeInterval)
            } else {
                return nil
            }
        }
        var modificationDate: Date? {
            if let modificationDateTimeInterval = dictionary["modificationDate"] as? TimeInterval {
                return Date(timeIntervalSince1970: modificationDateTimeInterval)
            } else {
                return nil
            }
        }
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isDone: isDone,
            creationDate: creationDate,
            modificationDate: modificationDate
        )
    }
    
}
