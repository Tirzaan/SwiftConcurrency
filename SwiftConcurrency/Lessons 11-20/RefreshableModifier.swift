// Lesson 15
//
//  RefreshableModifier.swift
//  SwiftConcurrency
//
//  Created by Tirzaan on 9/20/25.
//

import SwiftUI

final class RefreshableModifierDataService {
    func getData() async throws -> [String] {
//        try? await Task.sleep(for: .seconds(5))
        return [
            "Pizza",
            "Burger",
            "Hot Dog",
            "French Fries",
            "Fried Chicken",
            "Pasta",
            "Spaghetti",
            "Lasagna",
            "Tacos",
            "Burrito",
            "Quesadilla",
            "Nachos",
            "Ramen",
            "Sushi",
            "Tempura",
            "Curry",
            "Steak",
            "Salmon",
            "Shrimp",
            "Lobster",
            "Crab",
            "Clam Chowder"
        ].shuffled()
    }
}

@MainActor
final class RefreshableModifierViewModel: ObservableObject {
    @Published private(set) var items: [String] = []
    let manager = RefreshableModifierDataService()
    
    func loadData() async {
        try? await Task.sleep(for: .seconds(5))
        Task {
            do {
                items = try await manager.getData()
            } catch {
                print(error)
            }
        }
    }
 }

struct RefreshableModifier: View {
    @StateObject private var viewModel = RefreshableModifierViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.items, id: \.self) { item in
                        Text(item)
                            .font(.headline)
                    }
                }
            }
            .refreshable {
                await viewModel.loadData()
            }
            .navigationTitle("Refreshable")
            .task {
                await viewModel.loadData()
            }
        }
    }
}

#Preview {
    RefreshableModifier()
}
