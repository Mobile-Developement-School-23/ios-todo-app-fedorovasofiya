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
    
    func testJsonValueWhichShouldHaveAllProperties() throws {
        let item = TodoItem(text: "text", importance: .unimportant, deadline: .now + 100, modificationDate: .now + 10)
        let json = try XCTUnwrap(item.json as? Dictionary<String, Any>)
        XCTAssertEqual(json.count, 7)
    }
    
    func testJsonValueWithAllPropertiesExceptDeadline() throws {
        let item = TodoItem(text: "text", importance: .unimportant, deadline: nil, modificationDate: .now + 10)
        let json = try XCTUnwrap(item.json as? Dictionary<String, Any>)
        XCTAssertEqual(json.count, 6)
    }
    
    func testJsonValueWithAllPropertiesExceptModificationDate() throws {
        let item = TodoItem(text: "text", importance: .unimportant, deadline: .now + 100, modificationDate: nil)
        let json = try XCTUnwrap(item.json as? Dictionary<String, Any>)
        XCTAssertEqual(json.count, 6)
    }
    
    func testJsonValueWithRegularImportance() throws {
        let item = TodoItem(text: "text", importance: .regular, deadline: .now + 100, modificationDate: .now + 10)
        let json = try XCTUnwrap(item.json as? Dictionary<String, Any>)
        XCTAssertFalse(json.values.contains(where: { $0 as? String == item.importance.rawValue }))
    }
    
    func testEquivalencyOfJsonValue() throws {
        let item = TodoItem(text: "text", importance: .unimportant, deadline: .now + 100, modificationDate: .now + 10)
        let json = try XCTUnwrap(item.json as? Dictionary<String, Any>)
        XCTAssertTrue(json.values.contains(where: { $0 as? String == item.id.uuidString }))
        XCTAssertTrue(json.values.contains(where: { $0 as? String == item.text }))
        XCTAssertTrue(json.values.contains(where: { $0 as? String == item.importance.rawValue }))
        XCTAssertTrue(json.values.contains(where: { $0 as? Double == item.deadline?.timeIntervalSince1970 }))
        XCTAssertTrue(json.values.contains(where: { $0 as? Bool == item.isDone }))
        XCTAssertTrue(json.values.contains(where: { $0 as? Double == item.creationDate.timeIntervalSince1970 }))
        XCTAssertTrue(json.values.contains(where: { $0 as? Double == item.modificationDate?.timeIntervalSince1970 }))
    }
    
    func testEquivalencyOfJsonParsing() {
        let item = TodoItem(text: "text", importance: .unimportant, deadline: .now + 100, modificationDate: .now + 10)
        var dictionary: [String : Any] = [:]
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
    
    func testJsonParsingWithInvalidJsonArgument() {
        let dictionary: Dictionary<Int, Int> = [1 : 2, 3 : 4]
        let parsedItem = TodoItem.parse(json: dictionary)
        XCTAssertNil(parsedItem)
    }
    
    func testJsonParsingWithoutImportance() {
        var dictionary: [String : Any] = [:]
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
    
    func testJsonParsingWithoutDeadline() {
        var dictionary: [String : Any] = [:]
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
    
    func testJsonParsingWithoutModificationDate() {
        var dictionary: [String : Any] = [:]
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
    
    func testJsonParsingWithInvalidId() {
        var dictionary: [String : Any] = [:]
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
    
    func testJsonParsingWithoutId() {
        var dictionary: [String : Any] = [:]
        dictionary["text"] = "text"
        dictionary["importance"] = TodoItem.Importance.important.rawValue
        dictionary["deadline"] = Date().timeIntervalSince1970
        dictionary["isDone"] = true
        dictionary["creationDate"] = Date().timeIntervalSince1970
        dictionary["modificationDate"] = Date().timeIntervalSince1970
        let parsedItem = TodoItem.parse(json: dictionary)
        XCTAssertNil(parsedItem)
    }
    
    func testJsonParsingWithIncorrectImportance() {
        var dictionary: [String : Any] = [:]
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
    
    func testJsonParsingWithoutText() {
        var dictionary: [String : Any] = [:]
        dictionary["id"] = UUID().uuidString
        dictionary["importance"] = "123"
        dictionary["deadline"] = Date().timeIntervalSince1970
        dictionary["isDone"] = true
        dictionary["creationDate"] = Date().timeIntervalSince1970
        dictionary["modificationDate"] = Date().timeIntervalSince1970
        let parsedItem = TodoItem.parse(json: dictionary)
        XCTAssertNil(parsedItem)
    }
    
    func testJsonParsingWithIncorrectCreationDate() {
        var dictionary: [String : Any] = [:]
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
    
    func testJsonParsingWithoutIsDone() {
        var dictionary: [String : Any] = [:]
        dictionary["id"] = UUID().uuidString
        dictionary["text"] = "text"
        dictionary["importance"] = TodoItem.Importance.important.rawValue
        dictionary["deadline"] = Date().timeIntervalSince1970
        dictionary["creationDate"] = Date().timeIntervalSince1970
        dictionary["modificationDate"] = Date().timeIntervalSince1970
        let parsedItem = TodoItem.parse(json: dictionary)
        XCTAssertNil(parsedItem)
    }
    
    func testJsonParsingWithIncorrectIsDoneValue() {
        var dictionary: [String : Any] = [:]
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
    
    func testCsvValueWithAllPropertiesExceptDeadline() {
        let item = TodoItem(text: "text", importance: .unimportant, deadline: nil, modificationDate: .now + 10)
        let csvString = item.csv
        let columns = csvString.components(separatedBy: TodoItem.csvColumnsDelimiter)
        XCTAssertEqual(columns.count, 7)
        XCTAssertTrue(columns[3].isEmpty)
    }

    func testCsvValueWithAllPropertiesExceptModificationDate() {
        let item = TodoItem(text: "text", importance: .unimportant, deadline: .now + 100, modificationDate: nil)
        let csvString = item.csv
        let columns = csvString.components(separatedBy: TodoItem.csvColumnsDelimiter)
        XCTAssertEqual(columns.count, 7)
        XCTAssertTrue(columns[6].isEmpty)
    }

    func testCsvValueWithRegularImportance() {
        let item = TodoItem(text: "text", importance: .regular, deadline: .now + 100, modificationDate: .now + 10)
        let csvString = item.csv
        let columns = csvString.components(separatedBy: TodoItem.csvColumnsDelimiter)
        XCTAssertEqual(columns.count, 7)
        XCTAssertTrue(columns[2].isEmpty)
    }

    func testEquivalencyOfCsvValue() {
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
    
    func testEquivalencyOfCsvParsing() throws {
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

    func testCsvParsingWithInvalidCsvArgument() {
        let invalidString = "abcdef12345"
        let parsedItem = TodoItem.parse(csv: invalidString)
        XCTAssertNil(parsedItem)
    }
    
    func testCsvParsingWithIncorrectColumnsCount() {
        var csv: String = String()
        csv.append(UUID().uuidString)
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append("text")
        csv.append(TodoItem.csvColumnsDelimiter)
        csv.append(TodoItem.Importance.important.rawValue)
        
        let parsedItem = TodoItem.parse(csv: csv)
        XCTAssertNil(parsedItem)
    }

    func testCsvParsingWithoutImportance() {
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

    func testCsvParsingWithoutDeadline() {
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

    func testCsvParsingWithoutModificationDate() throws {
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

    func testCsvParsingWithInvalidId() {
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

    func testCsvParsingWithoutId() throws {
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

    func testCsvParsingWithIncorrectImportance() {
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

    func testCsvParsingWithIncorrectCreationDate() throws {
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

    func testCsvParsingWithoutIsDone() throws {
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

    func testCsvParsingWithIncorrectIsDoneValue() throws {
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
