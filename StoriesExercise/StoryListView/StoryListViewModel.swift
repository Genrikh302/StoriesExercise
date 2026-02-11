//
//  StoryListViewModel.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import Foundation

@Observable
public final class StoryListViewModel {
    enum ViewState: Equatable {
        case idle
        case loading
        case error(String)
    }
    
    var storyItems: [StoryBO] = []
    var state: ViewState = .idle

    @ObservationIgnored private let pageSize = 30
    @ObservationIgnored private let maxWindowSize = 60
    @ObservationIgnored private var currentPage: Int = 0
    @ObservationIgnored private var isLoadingPage = false
    @ObservationIgnored private let repository: StoriesRepositoryProtocol

    init(repository: StoriesRepositoryProtocol = StoriesRepository()) {
        self.repository = repository
//        Task {
//            await loadNextPageIfNeeded(currentItem: nil)
//        }
    }
}

public extension StoryListViewModel {
    func itemTapped(item: StoryBO) {
        print("XX: item tapped \(item)")
    }

    func loadNextPageIfNeeded(currentItem: StoryBO?) async {
        guard shouldLoadMore(currentItem: currentItem), !isLoadingPage else { return }

        isLoadingPage = true
        state = .loading
        defer { isLoadingPage = false }

        do {
            let newStories = try await repository.loadStories(
                page: currentPage,
                pageSize: pageSize
            )

            storyItems.append(contentsOf: newStories)
            currentPage += 1
            trimWindowIfNeeded()

            state = .idle

        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

private extension StoryListViewModel {
    private func shouldLoadMore(currentItem: StoryBO?) -> Bool {
        guard let currentItem else { return true }
        guard let index = storyItems.firstIndex(of: currentItem) else { return false }

        // If we are 5 items away from the end we need to load more
        let thresholdIndex = storyItems.index(
            storyItems.endIndex,
            offsetBy: -5,
            limitedBy: storyItems.startIndex
        ) ?? storyItems.startIndex
        return index >= thresholdIndex
    }

    private func trimWindowIfNeeded() {
        guard storyItems.count > maxWindowSize else { return }
        let excess = storyItems.count - maxWindowSize
        storyItems.removeFirst(excess)
    }
}
