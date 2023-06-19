//
//  TodoItemTests.swift
//  TodoItemTests
//
//  Created by Sonya Fedorova on 16.06.2023.
//

import XCTest
@testable import ToDoApp

final class TodoItemTests: XCTestCase {
    
    func testIsDoneValueAfterDefaultInit() {
        let item = TodoItem(text: "text", importance: .important, deadline: nil, modificationDate: nil)
        XCTAssertEqual(item.isDone, false)
    }
    
    func testEquivalencyOfJSONValue() throws {
        let item = TodoItem(text: "text", importance: .unimportant, deadline: .now + 100, modificationDate: .now + 10)
        let json = try XCTUnwrap(item.json as? [String: Any])
        XCTAssertEqual(json.count, 7)
        XCTAssertTrue(json.values.contains(where: { $0 as? String == item.id.uuidString }))
        XCTAssertTrue(json.values.contains(where: { $0 as? String == item.text }))
        XCTAssertTrue(json.values.contains(where: { $0 as? String == item.importance.rawValue }))
        XCTAssertTrue(json.values.contains(where: { $0 as? Double == item.deadline?.timeIntervalSince1970 }))
        XCTAssertTrue(json.values.contains(where: { $0 as? Bool == item.isDone }))
        XCTAssertTrue(json.values.contains(where: { $0 as? Double == item.creationDate.timeIntervalSince1970 }))
        XCTAssertTrue(json.values.contains(where: { $0 as? Double == item.modificationDate?.timeIntervalSince1970 }))
    }
    
    func testJSONValueWithAllPropertiesExceptDeadline() throws {
        let item = TodoItem(text: "text", importance: .unimportant, deadline: nil, modificationDate: .now + 10)
        let json = try XCTUnwrap(item.json as? [String: Any])
        XCTAssertEqual(json.count, 6)
    }
    
    func testJSONValueWithAllPropertiesExceptModificationDate() throws {
        let item = TodoItem(text: "text", importance: .unimportant, deadline: .now + 100, modificationDate: nil)
        let json = try XCTUnwrap(item.json as? [String: Any])
        XCTAssertEqual(json.count, 6)
    }
    
    func testJSONValueWithRegularImportance() throws {
        let item = TodoItem(text: "text", importance: .regular, deadline: .now + 100, modificationDate: .now + 10)
        let json = try XCTUnwrap(item.json as? [String: Any])
        XCTAssertFalse(json.values.contains(where: { $0 as? String == item.importance.rawValue }))
    }
    
    func testEquivalencyOfJSONParsing() {
        let item = TodoItem(text: "text", importance: .unimportant, deadline: .now + 100, modificationDate: .now + 10)
        var dictionary: [String: Any] = [:]
        dictionary["id"] = item.id.uuidString
        dictionary["text"] = item.text
        dictionary["importance"] = item.importance.rawValue
        dictionary["deadline"] = item.deadline?.timeIntervalSince1970
        dictionary["isDone"] = item.isDone
        dictionary["creationDate"] = item.creationDate.timeIntervalSince1970
        dictionary["modificationDate"] = item.modificationDate?.timeIntervalSince1970
        
        let parsedItem = TodoItem.parse(json: dictionary)
        XCTAssertNotNil(parsedItem)
        XCTAssertEqual(parsedItem?.id, item.id)
        XCTAssertEqual(parsedItem?.text, item.text)
        XCTAssertEqual(parsedItem?.importance, item.importance)
        XCTAssertEqual(parsedItem?.deadline?.timeIntervalSince1970, item.deadline?.timeIntervalSince1970)
        XCTAssertEqual(parsedItem?.isDone, item.isDone)
        XCTAssertEqual(parsedItem?.creationDate.timeIntervalSince1970, item.creationDate.timeIntervalSince1970)
        XCTAssertEqual(parsedItem?.modificationDate?.timeIntervalSince1970, item.modificationDate?.timeIntervalSince1970)
    }
    
    func testJSONParsingWithInvalidJSONArgument() {
        let dictionary: [Int: Int] = [1: 2, 3: 4]
        let parsedItem = TodoItem.parse(json: dictionary)
        XCTAssertNil(parsedItem)
    }
    
    func testJSONParsingWithoutImportance() {
        var dictionary: [String: Any] = [:]
        dictionary["id"] = UUID().uuidString
        dictionary["text"] = "text"
        dictionary["deadline"] = Date().timeIntervalSince1970
        dictionary["isDone"] = true
        dictionary["creationDate"] = Date().timeIntervalSince1970
        dictionary["modificationDate"] = Date().timeIntervalSince1970
        let parsedItem = TodoItem.parse(json: dictionary)
        XCTAssertNotNil(parsedItem)
        XCTAssertEqual(parsedItem?.importance, TodoItem.Importance.regular)
    }
    
    func testJSONParsingWithoutDeadline() {
        var dictionary: [String: Any] = [:]
        dictionary["id"] = UUID().uuidString
        dictionary["text"] = "text"
        dictionary["importance"] = TodoItem.Importance.important.rawValue
        dictionary["isDone"] = true
        dictionary["creationDate"] = Date().timeIntervalSince1970
        dictionary["modificationDate"] = Date().timeIntervalSince1970
        let parsedItem = TodoItem.parse(json: dictionary)
        XCTAssertNotNil(parsedItem)
        XCTAssertNil(parsedItem?.deadline)
    }
    
    func testJSONParsingWithoutModificationDate() {
        var dictionary: [String: Any] = [:]
        dictionary["id"] = UUID().uuidString
        dictionary["text"] = "text"
        dictionary["importance"] = TodoItem.Importance.important.rawValue
        dictionary["deadline"] = Date().timeIntervalSince1970
        dictionary["isDone"] = true
        dictionary["creationDate"] = Date().timeIntervalSince1970
        let parsedItem = TodoItem.parse(json: dictionary)
        XCTAssertNotNil(parsedItem)
        XCTAssertNil(parsedItem?.modificationDate)
    }
    
    func testJSONParsingWithInvalidId() {
        var dictionary: [String: Any] = [:]
        dictionary["id"] = "abc"
        dictionary["text"] = "text"
        dictionary["importance"] = TodoItem.Importance.important.rawValue
        dictionary["deadline"] = Date().timeIntervalSince1970
        dictionary["isDone"] = true
        dictionary["creationDate"] = Date().timeIntervalSince1970
        dictionary["modificationDate"] = Date().timeIntervalSince1970
        let parsedItem = TodoItem.parse(json: dictionary)
        XCTAssertNil(parsedItem)
    }
    
    func testJSONParsingWithoutId() {
        var dictionary: [String: Any] = [:]
        dictionary["text"] = "text"
        dictionary["importance"] = TodoItem.Importance.important.rawValue
        dictionary["deadline"] = Date().timeIntervalSince1970
        dictionary["isDone"] = true
        dictionary["creationDate"] = Date().timeIntervalSince1970
        dictionary["modificationDate"] = Date().timeIntervalSince1970
        let parsedItem = TodoItem.parse(json: dictionary)
        XCTAssertNil(parsedItem)
    }
    
    func testJSONParsingWithIncorrectImportance() {
        var dictionary: [String: Any] = [:]
        dictionary["id"] = UUID().uuidString
        dictionary["text"] = "text"
        dictionary["importance"] = "123"
        dictionary["deadline"] = Date().timeIntervalSince1970
        dictionary["isDone"] = true
        dictionary["creationDate"] = Date().timeIntervalSince1970
        dictionary["modificationDate"] = Date().timeIntervalSince1970
        let parsedItem = TodoItem.parse(json: dictionary)
        XCTAssertNil(parsedItem)
    }
    
    func testJSONParsingWithoutText() {
        var dictionary: [String: Any] = [:]
        dictionary["id"] = UUID().uuidString
        dictionary["importance"] = "123"
        dictionary["deadline"] = Date().timeIntervalSince1970
        dictionary["isDone"] = true
        dictionary["creationDate"] = Date().timeIntervalSince1970
        dictionary["modificationDate"] = Date().timeIntervalSince1970
        let parsedItem = TodoItem.parse(json: dictionary)
        XCTAssertNil(parsedItem)
    }
    
    func testJSONParsingWithIncorrectCreationDate() {
        var dictionary: [String: Any] = [:]
        dictionary["id"] = UUID().uuidString
        dictionary["text"] = "text"
        dictionary["importance"] = TodoItem.Importance.important.rawValue
        dictionary["deadline"] = Date().timeIntervalSince1970
        dictionary["isDone"] = true
        dictionary["creationDate"] = "123"
        dictionary["modificationDate"] = Date().timeIntervalSince1970
        let parsedItem = TodoItem.parse(json: dictionary)
        XCTAssertNil(parsedItem)
    }
    
    func testJSONParsingWithoutIsDone() {
        var dictionary: [String: Any] = [:]
        dictionary["id"] = UUID().uuidString
        dictionary["text"] = "text"
        dictionary["importance"] = TodoItem.Importance.important.rawValue
        dictionary["deadline"] = Date().timeIntervalSince1970
        dictionary["creationDate"] = Date().timeIntervalSince1970
        dictionary["modificationDate"] = Date().timeIntervalSince1970
        let parsedItem = TodoItem.parse(json: dictionary)
        XCTAssertNil(parsedItem)
    }
    
    func testJSONParsingWithIncorrectIsDoneValue() {
        var dictionary: [String: Any] = [:]
        dictionary["id"] = UUID().uuidString
        dictionary["text"] = "text"
        dictionary["importance"] = TodoItem.Importance.important.rawValue
        dictionary["deadline"] = Date().timeIntervalSince1970
        dictionary["isDone"] = "123"
        dictionary["creationDate"] = Date().timeIntervalSince1970
        dictionary["modificationDate"] = Date().timeIntervalSince1970
        let parsedItem = TodoItem.parse(json: dictionary)
        XCTAssertNil(parsedItem)
    }
    
    func testEquivalencyOfCSVValue() {
        let item = TodoItem(text: "text", importance: .unimportant, deadline: .now + 100, modificationDate: .now + 10)
        let csvString = item.csv
        let columns = csvString.components(separatedBy: TodoItem.csvColumnsDelimiter)
        XCTAssertEqual(columns.count, 7)
        XCTAssertEqual(columns[0], item.id.uuidString)
        XCTAssertEqual(columns[1], item.text)
        XCTAssertEqual(columns[2], item.importance.rawValue)
        XCTAssertEqual(Double(columns[3]), item.deadline?.timeIntervalSince1970)
        XCTAssertEqual(Int(columns[4]) != 0, item.isDone)
        XCTAssertEqual(Double(columns[5]), item.creationDate.timeIntervalSince1970)
        XCTAssertEqual(Double(columns[6]), item.modificationDate?.timeIntervalSince1970)
    }
    
    func testCSVValueWithAllPropertiesExceptDeadline() {
        let item = TodoItem(text: "text", importance: .unimportant, deadline: nil, modificationDate: .now + 10)
        let csvString = item.csv
        let columns = csvString.components(separatedBy: TodoItem.csvColumnsDelimiter)
        XCTAssertEqual(columns.count, 7)
        XCTAssertTrue(columns[3].isEmpty)
    }

    func testCSVValueWithAllPropertiesExceptModificationDate() {
        let item = TodoItem(text: "text", importance: .unimportant, deadline: .now + 100, modificationDate: nil)
        let csvString = item.csv
        let columns = csvString.components(separatedBy: TodoItem.csvColumnsDelimiter)
        XCTAssertEqual(columns.count, 7)
        XCTAssertTrue(columns[6].isEmpty)
    }

    func testCSVValueWithRegularImportance() {
        let item = TodoItem(text: "text", importance: .regular, deadline: .now + 100, modificationDate: .now + 10)
        let csvString = item.csv
        let columns = csvString.components(separatedBy: TodoItem.csvColumnsDelimiter)
        XCTAssertEqual(columns.count, 7)
        XCTAssertTrue(columns[2].isEmpty)
    }
    
    func testEquivalencyOfCSVParsing() throws {
        let item = TodoItem(text: "text", importance: .unimportant, deadline: .now + 100, modificationDate: .now + 10)
        var csv: String = String()
        csv.append(item.id.uuidString)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(item.text)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(item.importance.rawValue)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(try XCTUnwrap(item.deadline?.timeIntervalSince1970.description))
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append((item.isDone ? 1 : 0).description)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(item.creationDate.timeIntervalSince1970.description)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(try XCTUnwrap(item.modificationDate?.timeIntervalSince1970.description))
        
        let parsedItem = TodoItem.parse(csv: csv)
        XCTAssertNotNil(parsedItem)
        XCTAssertEqual(parsedItem?.id, item.id)
        XCTAssertEqual(parsedItem?.text, item.text)
        XCTAssertEqual(parsedItem?.importance, item.importance)
        XCTAssertEqual(parsedItem?.deadline?.timeIntervalSince1970, item.deadline?.timeIntervalSince1970)
        XCTAssertEqual(parsedItem?.isDone, item.isDone)
        XCTAssertEqual(parsedItem?.creationDate.timeIntervalSince1970, item.creationDate.timeIntervalSince1970)
        XCTAssertEqual(parsedItem?.modificationDate?.timeIntervalSince1970, item.modificationDate?.timeIntervalSince1970)
    }

    func testCSVParsingWithInvalidCSVArgument() {
        let invalidString = "abcdef12345"
        let parsedItem = TodoItem.parse(csv: invalidString)
        XCTAssertNil(parsedItem)
    }
    
    func testCSVParsingWithIncorrectColumnsCount() {
        var csv: String = String()
        csv.append(UUID().uuidString)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("text")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(TodoItem.Importance.important.rawValue)
        
        let parsedItem = TodoItem.parse(csv: csv)
        XCTAssertNil(parsedItem)
    }

    func testCSVParsingWithoutImportance() {
        var csv: String = String()
        csv.append(UUID().uuidString)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("text")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("1")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        
        let parsedItem = TodoItem.parse(csv: csv)
        XCTAssertNotNil(parsedItem)
        XCTAssertEqual(parsedItem?.importance, TodoItem.Importance.regular)
    }

    func testCSVParsingWithoutDeadline() {
        var csv: String = String()
        csv.append(UUID().uuidString)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("text")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(TodoItem.Importance.important.rawValue)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("1")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        
        let parsedItem = TodoItem.parse(csv: csv)
        XCTAssertNotNil(parsedItem)
        XCTAssertNil(parsedItem?.deadline)
    }

    func testCSVParsingWithoutModificationDate() throws {
        var csv: String = String()
        csv.append(UUID().uuidString)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("text")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(TodoItem.Importance.important.rawValue)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("1")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        csv.append(TodoItem.csvColumnsDelimiter)
        
        let parsedItem = TodoItem.parse(csv: csv)
        XCTAssertNotNil(parsedItem)
        XCTAssertNil(parsedItem?.modificationDate)
    }

    func testCSVParsingWithInvalidId() {
        var csv: String = String()
        csv.append("abc")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("text")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(TodoItem.Importance.important.rawValue)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("1")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        
        let parsedItem = TodoItem.parse(csv: csv)
        XCTAssertNil(parsedItem)
    }

    func testCSVParsingWithoutId() throws {
        var csv: String = String()
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("text")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(TodoItem.Importance.important.rawValue)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("1")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        
        let parsedItem = TodoItem.parse(csv: csv)
        XCTAssertNil(parsedItem)
    }

    func testCSVParsingWithIncorrectImportance() {
        var csv: String = String()
        csv.append(UUID().uuidString)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("text")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("123")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("1")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        
        let parsedItem = TodoItem.parse(csv: csv)
        XCTAssertNil(parsedItem)
    }

    func testCSVParsingWithIncorrectCreationDate() throws {
        var csv: String = String()
        csv.append(UUID().uuidString)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("text")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(TodoItem.Importance.important.rawValue)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("1")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        
        let parsedItem = TodoItem.parse(csv: csv)
        XCTAssertNil(parsedItem)
    }

    func testCSVParsingWithoutIsDone() throws {
        var csv: String = String()
        csv.append(UUID().uuidString)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("text")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(TodoItem.Importance.important.rawValue)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        
        let parsedItem = TodoItem.parse(csv: csv)
        XCTAssertNil(parsedItem)
    }

    func testCSVParsingWithIncorrectIsDoneValue() throws {
        var csv: String = String()
        csv.append(UUID().uuidString)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("text")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(TodoItem.Importance.important.rawValue)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("12345")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(Date().timeIntervalSince1970.description)
        
        let parsedItem = TodoItem.parse(csv: csv)
        XCTAssertNil(parsedItem)
    }

}
