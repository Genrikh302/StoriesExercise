//
//  StoryItemView.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import SwiftUI

struct StoryListItemView: View {
    let id: Int

    var body: some View {
        VStack(spacing: 0) {
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 72, height: 72)
                .overlay(
                    Text("\(id)")
                        .font(.caption)
                )

            Text("Story \(id)")
                .font(.caption2)
        }
    }
}
