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

        let maxDimension = 500
        var compactWidth = input.width
        var compactHeight = input.height
        if input.width > maxDimension || input.height > maxDimension {
            compactWidth = input.width / 10
            compactHeight = input.height / 10
        }

        let compactURL = URL(
            string: "https://picsum.photos/id/\(input.id)/\(compactWidth)/\(compactHeight)"
        )!

        // Also downsize generally large images this API sometimes return 5000x5000 photos
        let maxFullDimension = 1000
        var fullWidth = input.width
        var fullHeight = input.height
        if input.width > maxFullDimension || input.height > maxFullDimension {
            fullWidth = input.width / 5
            fullHeight = input.height / 5
        }

        let fullImageURL = URL(
            string: "https://picsum.photos/id/\(input.id)/\(fullWidth)/\(fullHeight)"
        )!


        return StoryBO(
            id: input.id,
            author: input.author,
            compactImageURL: compactURL,
            fullImageURL: fullImageURL
        )
    }
}
