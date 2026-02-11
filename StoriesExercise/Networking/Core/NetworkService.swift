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
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - Repository Protocol

protocol StoriesRepositoryProtocol {
    func loadStories(page: Int, pageSize: Int) async throws -> [StoryDTO]
}

// MARK: - Repository Implementation

final class StoriesRepository: StoriesRepositoryProtocol {

    private let networkService: NetworkServicing

    init(networkService: NetworkServicing = NetworkService()) {
        self.networkService = networkService
    }

    func loadStories(page: Int, pageSize: Int) async throws -> [StoryDTO] {
        let endpoint = StoryListEndpoint.fetchStories(page: page, pageSize: pageSize)
        // need to implement infinite scrolling by replacing page in it's gone too far
        return try await networkService.request(endpoint)
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
