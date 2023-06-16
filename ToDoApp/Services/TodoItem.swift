//
//  TodoItem.swift
//  ToDoList
//
//  Created by Sonya Fedorova on 15.06.2023.
//

import Foundation

struct TodoItem: Hashable {
    
    enum Importance: String, CaseIterable {
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

// MARK: - CSV Parsing

extension TodoItem {
    
    static let csvColumnsDelimiter = ";"
    static let csvRowsDelimiter = "\r"
    static let csvTitles = "id;text;importance;deadline;isDone;creationDate;modificationDate"
    
    var csv: String {
        var string = String()
        string.append(id.uuidString)
        string.append(TodoItem.csvColumnsDelimiter)
        string.append(text)
        string.append(TodoItem.csvColumnsDelimiter)
        if importance != .regular {
            string.append(importance.rawValue)
        }
        string.append(TodoItem.csvColumnsDelimiter)
        if let deadline = deadline {
            string.append(deadline.timeIntervalSince1970.description)
        }
        string.append(TodoItem.csvColumnsDelimiter)
        string.append((isDone ? 1 : 0).description)
        string.append(TodoItem.csvColumnsDelimiter)
        string.append(creationDate.timeIntervalSince1970.description)
        string.append(TodoItem.csvColumnsDelimiter)
        if let modificationDate = modificationDate {
            string.append(modificationDate.timeIntervalSince1970.description)
        }
        return string
    }
    
    static func parse(csv: String) -> TodoItem? {
        let columns = csv.components(separatedBy: TodoItem.csvColumnsDelimiter)
        
        guard
            columns.count == 7,
            let id = UUID(uuidString: columns[0]),
            let importance = Importance(rawValue: (columns[2].isEmpty ? "обычная" : columns[2])),
            let isDoneInt = Int(columns[4]),
            isDoneInt == 0 || isDoneInt == 1,
            let creationDateTimeInterval = Double(columns[5])
        else { return nil }
        
        let text = columns[1]
        let isDone = isDoneInt != 0
        let creationDate = Date(timeIntervalSince1970: creationDateTimeInterval)
        
        var deadline: Date? {
            if let deadlineTimeInterval = Double(columns[3]) {
                return Date(timeIntervalSince1970: deadlineTimeInterval)
            } else {
                return nil
            }
        }
        var modificationDate: Date? {
            if let modificationDateTimeInterval = Double(columns[6]) {
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
