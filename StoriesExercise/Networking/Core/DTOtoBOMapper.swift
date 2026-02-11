//
//  DTOtoBOMapper.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import Foundation

// MARK: - Generic Mapper

protocol DTOtoBOMapper {
    associatedtype Input
    associatedtype Output

    func map(_ input: Input) -> Output
}

extension DTOtoBOMapper {
    func map(_ input: [Input]) -> [Output] {
        input.map { map($0) }
    }
}
