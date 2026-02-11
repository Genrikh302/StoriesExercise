//
//  StoryDTOMapper.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import Foundation

struct StoryDTOMapper: DTOtoBOMapper {
    func map(_ input: StoryDTO) -> StoryBO {

        // Create a compact sizing if the original is too big
        let fullURL = input.downloadUrl

        let maxDimension = 1000
        var compactWidth = input.width
        var compactHeight = input.height
        if input.width > maxDimension || input.height > maxDimension {
            compactWidth = input.width / 10
            compactHeight = input.height / 10
        }

        let compactURL = URL(
            string: "https://picsum.photos/id/\(input.id)/\(compactWidth)/\(compactHeight)"
        )!

        return StoryBO(
            id: input.id,
            author: input.author,
            compactImageURL: compactURL,
            fullImageURL: fullURL
        )
    }
}
