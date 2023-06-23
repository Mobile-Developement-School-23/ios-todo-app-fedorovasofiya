//
//  DateServiceImpl.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 22.06.2023.
//

import Foundation

final class DateServiceImpl: DateService {
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.setLocalizedDateFormatFromTemplate("d MMMM yyyy")
        return dateFormatter
    }
    
    func getDate(from string: String) -> Date? {
        dateFormatter.date(from: string)
    }
    
    func getString(from date: Date) -> String {
        dateFormatter.string(from: date)
    }
    
    func getNextDay() -> Date? {
        Calendar.current.date(byAdding: .day, value: 1, to: Date())
    }
    
}
