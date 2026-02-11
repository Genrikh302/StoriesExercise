//
//  StoryDTO.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import Foundation

struct StoryDTO: Identifiable, Decodable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: URL
    let downloadUrl: URL

    enum CodingKeys: String, CodingKey {
        case id
        case author
        case url
        case width
        case height
        case downloadUrl = "download_url"
    }
}
