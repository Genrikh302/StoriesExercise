//
//  NetworkService.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//


import Foundation

// MARK: - Network Service Protocol

protocol NetworkServicing {
    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> T
}

// MARK: - Network Service Implementation

final class NetworkService: NetworkServicing {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> T {
        let request = try endpoint.urlRequest()

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.badResponse
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}

//final class NetworkService: NetworkServicing {
//
//    private let session: URLSession
//
//    init(session: URLSession = .shared) {
//        self.session = session
//    }
//
//    func fetchStories(page: Int, pageSize: Int) async throws -> [StoryDTO] {
//        let endpoint = StoriesEndpoint.fetchStories(page: page, pageSize: pageSize)
//        let request = try endpoint.urlRequest()
//
//        let (data, response) = try await session.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse,
//              200..<300 ~= httpResponse.statusCode else {
//            throw URLError(.badServerResponse)
//        }
//
//        return try JSONDecoder().decode([StoryDTO].self, from: data)
//    }
//}
