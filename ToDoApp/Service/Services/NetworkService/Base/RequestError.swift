//
//  RequestError.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 05.07.2023.
//

import Foundation

enum RequestError: Error {
    case wrongURL(URLComponents)
    case unexpectedResponse
    case redirect
    case badRequest
    case serverError
    case unexpectedStatusCode(Int)
}

extension RequestError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .wrongURL(let urlComponents):
            return "Could not construct url with components: \(urlComponents)"
        case .unexpectedResponse:
            return "Unexpected response from server"
        case .redirect:
            return "Redirect"
        case .badRequest:
            return "Bad request"
        case .serverError:
            return "Server error"
        case .unexpectedStatusCode(let code):
            return "Unexpected status code: \(code)"
        }
    }
}
