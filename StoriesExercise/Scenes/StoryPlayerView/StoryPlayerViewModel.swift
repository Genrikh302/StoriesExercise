//
//  StoryPlayerViewModel.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//


import Foundation

@Observable
final class StoryPlayerViewModel {
    var currentIndex: Int
    var currentStory: StoryBO

    @ObservationIgnored var lastLoadedPage: Int
    @ObservationIgnored private var stories: [StoryBO]
    @ObservationIgnored private let pageSize = 10
    @ObservationIgnored private let repository: StoriesRepositoryProtocol
    @ObservationIgnored private let interactionStore: StoryInteractionStoring

    init(
        repository: StoriesRepositoryProtocol = StoriesRepository(),
        interactionStore: StoryInteractionStoring,
        stories: [StoryBO],
        initialIndex: Int,
        lastLoadedPage: Int
    ) {
        self.repository = repository
        self.interactionStore = interactionStore
        self.stories = stories
        self.currentIndex = initialIndex
        self.lastLoadedPage = lastLoadedPage
        self.currentStory = stories[initialIndex]

        fetchLikedStates()

        self.currentStory = self.stories[self.currentIndex]
        // Mark initially opened story as viewed
        markCurrentStoryViewed()
    }

    private var interactionsCache: [String: StoryInteractionEntity] = [:]

    private func fetchLikedStates() {
        for index in stories.indices { // This might be a lot of stories, better to limit it
            let id = stories[index].id

            if let interaction = interactionStore.interaction(for: id) {
                interactionsCache[id] = interaction
                stories[index].isLiked = interaction.isLiked
                stories[index].isViewed = interaction.isViewed
            }
        }
    }

    func goNext() {
        if currentIndex < stories.count - 1 {
            currentIndex += 1
            currentStory = stories[currentIndex]
            markCurrentStoryViewed()
            return
        } else {
            Task {
                await loadNextPageIfNeeded()
            }
        }
    }

    func goPrevious() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        currentStory = stories[currentIndex]
        markCurrentStoryViewed()
    }

    func toggleLike() {
        let id = currentStory.id
        interactionStore.toggleLike(storyID: id)

        if let interaction = interactionStore.interaction(for: id) {
            interactionsCache[id] = interaction
            currentStory.isLiked = interaction.isLiked
            stories[currentIndex] = currentStory
        }
    }

    func markCurrentStoryViewed() {
        let id = currentStory.id
        interactionStore.markViewed(storyID: id)

        if let interaction = interactionStore.interaction(for: id) {
            interactionsCache[id] = interaction
            currentStory.isViewed = interaction.isViewed
            stories[currentIndex] = currentStory
        }
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

            for index in stories.indices {
                let id = stories[index].id
                if let interaction = interactionStore.interaction(for: id) {
                    interactionsCache[id] = interaction
                    stories[index].isLiked = interaction.isLiked
                    stories[index].isViewed = interaction.isViewed
                }
            }

            lastLoadedPage = nextPage

            currentIndex += 1
            currentStory = stories[currentIndex]
            markCurrentStoryViewed()
        } catch {
            print("StoryPlayer pagination error: \(error)")
        }
    }
}
