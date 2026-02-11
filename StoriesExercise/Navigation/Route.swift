//
//  Route.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 12.02.2026..
//

import Foundation

enum Route: Equatable, Identifiable {
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
