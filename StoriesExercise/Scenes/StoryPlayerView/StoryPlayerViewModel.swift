//
//  StoryPlayerViewModel.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import Foundation

@Observable
final class StoryPlayerViewModel {
    var stories: [StoryBO]
    var currentIndex: Int

    @ObservationIgnored var lastLoadedPage: Int
    @ObservationIgnored private let pageSize = 10
    @ObservationIgnored private let repository: StoriesRepositoryProtocol

    init(
        repository: StoriesRepositoryProtocol = StoriesRepository(),
        stories: [StoryBO],
        initialIndex: Int,
        lastLoadedPage: Int
    ) {
        self.repository = repository
        self.stories = stories
        self.currentIndex = initialIndex
        self.lastLoadedPage = lastLoadedPage
    }

    var currentStory: StoryBO {
        stories[currentIndex]
    }

    func goNext() {
        if currentIndex < stories.count - 1 {
            currentIndex += 1
            return
        } else {
            print("XX: load more")

            // Need to load next page
            Task {
                await loadNextPageIfNeeded()
            }
        }
    }

    func goPrevious() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
    }

    private func loadNextPageIfNeeded() async {
        do {
            let nextPage = lastLoadedPage + 1
            let newStories = try await repository.loadStories(
                page: nextPage,
                pageSize: pageSize
            )

            guard !newStories.isEmpty else { return }

            stories.append(contentsOf: newStories)
            lastLoadedPage = nextPage

            currentIndex += 1
        } catch {
            print("StoryPlayer pagination error: \(error)")
        }
    }
}
