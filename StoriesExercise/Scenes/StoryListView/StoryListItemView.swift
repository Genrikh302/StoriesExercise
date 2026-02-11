//
//  StoryItemView.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import SwiftUI

struct StoryListItemView: View {
    let story: StoryBO

    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: story.compactImageURL) { phase in
                switch phase {
                case .empty:
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            ProgressView()
                        )
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            Image(systemName: "photo") // replace with some funky gradient maybe
                        )
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 72, height: 72)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(
                        story.isViewed
                        ? AnyShapeStyle(Color.gray.opacity(0.5))
                        : AnyShapeStyle(
                            LinearGradient(
                                colors: [.pink, .orange, .yellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        ),
                        lineWidth: 3
                    )
            )

            Text(story.author)
                .font(.caption2)
                .lineLimit(1)
        }
    }
}
