//
//  StoryBO.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import Foundation

public struct StoryBO: Identifiable, Hashable {
    public let id: String
    public let author: String
    public let compactImageURL: URL
    public let fullImageURL: URL

    public var isLiked: Bool = false
    public var isViewd: Bool = false
}
