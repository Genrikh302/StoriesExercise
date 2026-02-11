//
//  StoryContentView.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import SwiftUI

struct StoryContentView: View {
    let story: StoryBO

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: story.fullImageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black)
                case .failure:
                    Text("Failed to load image")
                @unknown default:
                    Color.black
                }
            }

            Text(story.author)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
        }
    }
}
