//
//  SwiftUIView.swift
//  StoriesExercise
//
//  Created by Genrikh Mayorov on 11.02.2026..
//

import SwiftUI

@Observable
final class StoryListViewModel {
    var items: [Int] = []

    private let pageSize = 20
    private let maxWindowSize = 60
    private var currentPage: Int = 0

    init() {
//        loadNextPageIfNeeded(currentItem: nil)
    }

    func addMore() {
//        items.append(contentsOf: [1,2,3])
        Task {
            let stories = try await StoriesRepository().loadStories(page: 20, pageSize: 30)
            print("XX: story \(stories.first?.author)")
        }
    }

//    func loadNextPageIfNeeded(currentItem: Int?) {
//        guard shouldLoadMore(currentItem: currentItem) else { return }
//
//        let start = currentPage * pageSize
//        let end = start + pageSize
//        let newItems = Array(start..<end)
//
//        items.append(contentsOf: newItems)
//        currentPage += 1
//
//        trimWindowIfNeeded()
//    }
//
//    private func shouldLoadMore(currentItem: Int?) -> Bool {
//        guard let currentItem else { return true }
//        guard let index = items.firstIndex(of: currentItem) else { return false }
//
//        let thresholdIndex = items.index(items.endIndex, offsetBy: -5, limitedBy: items.startIndex) ?? items.startIndex
//        return index >= thresholdIndex
//    }
//
//    private func trimWindowIfNeeded() {
//        guard items.count > maxWindowSize else { return }
//        let excess = items.count - maxWindowSize
//        items.removeFirst(excess)
//    }
}

extension StoryListView {
    private enum Constants {
        static let verticalSpacing: CGFloat = 8
        static let horizontalSpacing: CGFloat = 16
        static let horizontalPadding: CGFloat = 16

        static let storyCircleSize: CGFloat = 72
        static let storyItemSpacing: CGFloat = 8
    }
}

struct StoryListView: View {
    @State var viewModel: StoryListViewModel

    init() {
        viewModel = StoryListViewModel() // injection?
    }

    var body: some View {
        VStack(spacing: Constants.verticalSpacing) {
            Button("add more") {
                viewModel.addMore()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: Constants.horizontalSpacing) {
                    ForEach(viewModel.items, id: \.self) { item in
                        StoryListItemView(id: item)
                            .onAppear {
//                                viewModel.loadNextPageIfNeeded(currentItem: item)
                            }
                    }
                }
                .padding(.horizontal, Constants.horizontalPadding)
            }
        }
    }
}

//#Preview {
//    SwiftUIView()
//}
