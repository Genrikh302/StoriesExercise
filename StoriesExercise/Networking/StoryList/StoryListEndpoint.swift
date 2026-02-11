//
//  StoryListEndpoint.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import Foundation

enum StoryListEndpoint: EndpointType {
    case fetchStories(page: Int, pageSize: Int)

    var baseURL: URL {
        URL(string: "https://picsum.photos/v2")!
    }

    var path: String {
        switch self {
        case .fetchStories:
            return "/list"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchStories:
            return .get
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .fetchStories(page, pageSize):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "pageSize", value: "\(pageSize)")
            ]
        }
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json"
        ]
    }
}
