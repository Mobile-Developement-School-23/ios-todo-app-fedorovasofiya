//
//  DateService.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 22.06.2023.
//

import Foundation

protocol DateService {
    func getDate(from string: String) -> Date?
    func getString(from date: Date) -> String
    func getNextDay() -> Date?
}
