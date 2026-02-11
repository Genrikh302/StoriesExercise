//
//  StoryInteractionEntity.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 12.02.2026..
//

import Foundation
import SwiftData

@Model
final class StoryInteractionEntity {
    @Attribute(.unique) var storyID: String
    var isLiked: Bool
    var isViewed: Bool

    init(storyID: String,
         isLiked: Bool = false,
         isViewed: Bool = false) {
        self.storyID = storyID
        self.isLiked = isLiked
        self.isViewed = isViewed
    }
}
