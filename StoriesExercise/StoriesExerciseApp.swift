//
//  StoriesExerciseApp.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import SwiftUI
import SwiftData

@main
struct StoriesExerciseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: StoryInteractionEntity.self)
    }
}
