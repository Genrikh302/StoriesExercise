//
//  ContentView.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        let interactionStore = SwiftDataStoryInteractionStore(context: modelContext)
        
        StoryListView(interactionStore: interactionStore)
    }
}
