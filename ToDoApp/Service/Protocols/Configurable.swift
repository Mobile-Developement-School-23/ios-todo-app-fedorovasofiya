//
//  Configurable.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 29.06.2023.
//

import Foundation

protocol Configurable: AnyObject {
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}
