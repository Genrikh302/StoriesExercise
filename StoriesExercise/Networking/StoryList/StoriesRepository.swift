//
//  StoriesRepository.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import Foundation

protocol StoriesRepositoryProtocol {
    func loadStories(page: Int, pageSize: Int) async throws -> [StoryBO]
}

final class StoriesRepository: StoriesRepositoryProtocol {

    private let networkService: NetworkServicing
    private let mapper: StoryDTOMapper

    init(
        networkService: NetworkServicing = NetworkService(),
        mapper: StoryDTOMapper = StoryDTOMapper()
    ) {
        self.networkService = networkService
        self.mapper = mapper
    }

    func loadStories(page: Int, pageSize: Int) async throws -> [StoryBO] {
        print("XX: loadStories \(page) \(pageSize)")
        let endpoint = StoryListEndpoint.fetchStories(page: page, pageSize: pageSize)
        let dtos: [StoryDTO] = try await networkService.request(endpoint)
        return mapper.map(dtos)
    }
}
