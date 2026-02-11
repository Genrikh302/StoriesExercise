//
//  StoryDTO.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import Foundation

// MARK: - StoryDTO

struct StoryDTO: Identifiable, Decodable {
    let id: String
    let author: String
    let url: URL
}
