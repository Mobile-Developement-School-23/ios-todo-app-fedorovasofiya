//
//  URLSession+Extensions.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 07.07.2023.
//

import Foundation

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            dataTask(with: urlRequest) { data, response, error in
                if let data = data, let response = response, error == nil {
                    continuation.resume(returning: (data, response))
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: RequestError.emptyResult)
                }
            }.resume()
        }
    }
}
