//
//  StoryBO.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import Foundation

struct StoryBO: Identifiable, Hashable {
    let id: String
    let author: String
    let compactImageURL: URL
    let fullImageURL: URL
}
