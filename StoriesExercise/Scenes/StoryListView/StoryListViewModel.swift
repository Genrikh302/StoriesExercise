//
//  StoryListViewModel.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import Foundation

enum Route: Identifiable { // move to separate file
    case storyPlayer(
        stories: [StoryBO],
        initialIndex: Int,
        lastLoadedPage: Int
    )

    var id: String {
        switch self {
        case .storyPlayer(_, let index, let lastLoadedPage):
            return "storyPlayer_\(index)_page_\(lastLoadedPage)"
        }
    }
}

@Observable
public final class StoryListViewModel {
    enum ViewState: Equatable {
        case idle
        case initialLoading
        case error(String)
    }

    var storyItems: [StoryBO] = []
    var state: ViewState = .idle
    var isPaginating = false
    var route: Route? = nil

    @ObservationIgnored private let repository: StoriesRepositoryProtocol
    @ObservationIgnored private let pageSize = 30
    @ObservationIgnored private var currentPage: Int = 1
    @ObservationIgnored private var isLoadingPage = false

    // Window-based pagination needs more time
    // @ObservationIgnored private var maxWindowSize: Int { pageSize * 2 }
    // @ObservationIgnored private var lowestPageLoaded: Int = 1
    // @ObservationIgnored private var highestPageLoaded: Int = 1


    init(repository: StoriesRepositoryProtocol = StoriesRepository()) {
        self.repository = repository
    }
}

public extension StoryListViewModel {
    func itemTapped(item: StoryBO) {
        guard let index = storyItems.firstIndex(of: item) else { return }

        route = .storyPlayer(
            stories: storyItems,
            initialIndex: index,
            lastLoadedPage: currentPage
        )
    }

    func loadNextPageIfNeeded(currentItem: StoryBO?) async {
        guard !isLoadingPage else { return }

        // Initial load
        if storyItems.isEmpty {
            await loadPage(page: currentPage)
            return
        }

        guard let currentItem,
              let index = storyItems.firstIndex(of: currentItem) else { return }

        let isNearEnd = index >= storyItems.count - 5

        if isNearEnd {
            await loadPage(page: currentPage + 1)
        }
    }

    private func loadPage(page: Int) async {
        isLoadingPage = true

        if storyItems.isEmpty {
            state = .initialLoading
        } else {
            isPaginating = true
        }

        defer {
            isLoadingPage = false
            isPaginating = false
        }

        do {
            let newStories = try await repository.loadStories(
                page: page,
                pageSize: pageSize
            )

            storyItems.append(contentsOf: newStories)
            currentPage = page
            state = .idle

        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

private extension StoryListViewModel {
    /*
    private func trimWindowIfNeeded(removingFromFront: Bool) {
        guard storyItems.count > maxWindowSize else { return }

        let excess = storyItems.count - maxWindowSize

        if removingFromFront {
            storyItems.removeFirst(excess)
            lowestPageLoaded += excess / pageSize
        } else {
            storyItems.removeLast(excess)
            highestPageLoaded -= excess / pageSize
        }
    }
    */
}
