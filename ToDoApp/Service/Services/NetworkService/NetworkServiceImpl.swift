//
//  NetworkServiceImpl.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 05.07.2023.
//

import Foundation

final class NetworkServiceImpl: NetworkService {

    private struct Configuration {
        static let scheme = "https"
        static let host = "beta.mrdekk.ru"
        static let path = "todobackend"
        static let token = "throatless"
    }

    private let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    // MARK: - Public Methods

    func loadTodoList() async throws -> [TodoItem] {
        let request = try makeGetRequest(path: "/\(Configuration.path)/list")
        let (data, _) = try await performRequest(request)
        let response = try JSONDecoder().decode(ListResponse.self, from: data)
        return response.list.compactMap(mapData(element:))
    }

    // MARK: - Private Methods

    private func makeURL(path: String) throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = Configuration.scheme
        urlComponents.host = Configuration.host
        urlComponents.path = path

        guard let url = urlComponents.url else {
            throw RequestError.wrongURL(urlComponents)
        }
        return url
    }

    private func makeGetRequest(path: String) throws -> URLRequest {
        let url = try makeURL(path: path)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(Configuration.token)", forHTTPHeaderField: "Authorization")
        return request
    }

    private func performRequest(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await urlSession.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.unexpectedResponse
        }
        try handleStatusCode(response: response)
        return (data, response)
    }

    private func handleStatusCode(response: HTTPURLResponse) throws {
        switch response.statusCode {
        case (100...299):
            return
        case (300...399):
            throw RequestError.redirect
        case (400...499):
            throw RequestError.badRequest
        case (500...599):
            throw RequestError.serverError
        default:
            throw RequestError.unexpectedStatusCode(response.statusCode)
        }
    }

    private func mapData(element: Element) -> TodoItem? {
        guard
            let id = UUID(uuidString: element.id),
            let importance = Importance(rawValue: element.importance),
            let textColor = element.color
        else {
            return nil
        }

        let creationDate = Date(timeIntervalSince1970: TimeInterval(element.creationDate))
        let deadline = element.deadline.map { Date(timeIntervalSince1970: TimeInterval($0)) }
        let modificationDate = Date(timeIntervalSince1970: TimeInterval(element.modificationDate))

        return TodoItem(
            id: id,
            text: element.text,
            importance: importance,
            deadline: deadline,
            isDone: element.done,
            creationDate: creationDate,
            modificationDate: modificationDate,
            textColor: textColor
        )
    }

}
