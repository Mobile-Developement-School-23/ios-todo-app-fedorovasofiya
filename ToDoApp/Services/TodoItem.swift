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
    
    private enum Properties: CodingKey {
        case id, text, importance, deadline, isDone, creationDate, modificationDate
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
        creationDate: Date = Date(),
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
        var dictionary: [String: Any] = [:]
        dictionary[Properties.id.stringValue] = id.uuidString
        dictionary[Properties.text.stringValue] = text
        if importance != .regular {
            dictionary[Properties.importance.stringValue] = importance.rawValue
        }
        dictionary[Properties.deadline.stringValue] = deadline?.timeIntervalSince1970
        dictionary[Properties.isDone.stringValue] = isDone
        dictionary[Properties.creationDate.stringValue] = creationDate.timeIntervalSince1970
        dictionary[Properties.modificationDate.stringValue] = modificationDate?.timeIntervalSince1970
        return dictionary
    }
    
    static func parse(json: Any) -> TodoItem? {
        guard
            let dictionary = json as? [String: Any],
            let idString = dictionary[Properties.id.stringValue] as? String,
            let id = UUID(uuidString: idString),
            let text = dictionary[Properties.text.stringValue] as? String,
            let importance = (dictionary[Properties.importance.stringValue] as? String)
                .map(Importance.init(rawValue:)) ?? Importance.regular,
            let isDone = dictionary[Properties.isDone.stringValue] as? Bool,
            let creationDateTimeInterval = dictionary[Properties.creationDate.stringValue] as? TimeInterval
        else { return nil }
    
        let creationDate = Date(timeIntervalSince1970: creationDateTimeInterval)
        let deadline = (dictionary[Properties.deadline.stringValue] as? TimeInterval)
            .map { interval in Date(timeIntervalSince1970: interval) }
        let modificationDate = (dictionary[Properties.modificationDate.stringValue] as? TimeInterval)
            .map { interval in Date(timeIntervalSince1970: interval) }
        
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
    
    static var csvTitles: String {
        var values = [String]()
        values.append(Properties.id.stringValue)
        values.append(Properties.text.stringValue)
        values.append(Properties.importance.stringValue)
        values.append(Properties.deadline.stringValue)
        values.append(Properties.isDone.stringValue)
        values.append(Properties.creationDate.stringValue)
        values.append(Properties.modificationDate.stringValue)
        return values.joined(separator: TodoItem.csvColumnsDelimiter)
    }
    
    var csv: String {
        var values = [String]()
        values.append(id.uuidString)
        values.append(text)
        values.append(importance != .regular ? importance.rawValue : "")
        values.append(deadline?.timeIntervalSince1970.description ?? "")
        values.append((isDone ? 1 : 0).description)
        values.append(creationDate.timeIntervalSince1970.description)
        values.append(modificationDate?.timeIntervalSince1970.description ?? "")
        return values.joined(separator: TodoItem.csvColumnsDelimiter)
    }
    
    static func parse(csv: String) -> TodoItem? {
        let columns = csv.components(separatedBy: TodoItem.csvColumnsDelimiter)
        
        guard
            columns.count == 7,
            let id = UUID(uuidString: columns[0]),
            let importance = (columns[2].isEmpty ? nil : columns[2]).map(Importance.init(rawValue:)) ?? .regular,
            let isDoneInt = Int(columns[4]),
            isDoneInt == 0 || isDoneInt == 1,
            let creationDateTimeInterval = TimeInterval(columns[5])
        else { return nil }
        
        let text = columns[1]
        let isDone = isDoneInt != 0
        let creationDate = Date(timeIntervalSince1970: creationDateTimeInterval)
        let deadline = TimeInterval(columns[3]).map { interval in Date(timeIntervalSince1970: interval) }
        let modificationDate = TimeInterval(columns[6]).map { interval in Date(timeIntervalSince1970: interval) }
        
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
