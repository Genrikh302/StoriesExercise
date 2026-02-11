//
//  SwiftDataStoryInteractionStore.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 12.02.2026..
//

import Foundation
import SwiftData

protocol StoryInteractionStoring {
    func interaction(for storyID: String) -> StoryInteractionEntity?
    func toggleLike(storyID: String)
    func markViewed(storyID: String)
}

@MainActor
final class SwiftDataStoryInteractionStore: StoryInteractionStoring {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func interaction(for storyID: String) -> StoryInteractionEntity? {
        let descriptor = FetchDescriptor<StoryInteractionEntity>(
            predicate: #Predicate { $0.storyID == storyID }
        )
        return try? context.fetch(descriptor).first
    }

    func toggleLike(storyID: String) {
        if let entity = interaction(for: storyID) {
            entity.isLiked.toggle()
        } else {
            let entity = StoryInteractionEntity(
                storyID: storyID,
                isLiked: true,
                isViewed: false
            )
            context.insert(entity)
        }
    }

    func markViewed(storyID: String) {
        if let entity = interaction(for: storyID) {
            entity.isViewed = true
        } else {
            let entity = StoryInteractionEntity(
                storyID: storyID,
                isLiked: false,
                isViewed: true
            )
            context.insert(entity)
        }
    }
}
