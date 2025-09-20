// Lesson 16
//
//  SearchableModifier.swift
//  SwiftConcurrency
//
//  Created by Tirzaan on 9/20/25.
//

import SwiftUI
import Combine

struct Restaurant: Identifiable, Hashable {
    let id: String
    let title: String
    var cuisine: CuisineOption
}

enum CuisineOption: String {
    case american
    case italian
    case japanese
}

final class RestaurantManager {
    func getAllRestaurants() async throws -> [Restaurant] {
        [
            Restaurant(id: "1", title: "Burger Shack", cuisine: .american),
            Restaurant(id: "2", title: "Pasta Palace", cuisine: .italian),
            Restaurant(id: "3", title: "Sushi Central", cuisine: .japanese),
            Restaurant(id: "4", title: "Burger Barn", cuisine: .american),
            Restaurant(id: "5", title: "Trattoria Toscana", cuisine: .italian),
            Restaurant(id: "6", title: "Tokyo Bites", cuisine: .japanese),
            Restaurant(id: "7", title: "Grill House", cuisine: .american),
            Restaurant(id: "8", title: "Mama Mia Pizza", cuisine: .italian),
            Restaurant(id: "9", title: "Samurai Sushi", cuisine: .japanese),
            Restaurant(id: "10", title: "Cheeseburger Club", cuisine: .american),
            Restaurant(id: "11", title: "Pasta Fresca", cuisine: .italian),
            Restaurant(id: "12", title: "Ramen Realm", cuisine: .japanese),
            Restaurant(id: "13", title: "All-American Diner", cuisine: .american),
            Restaurant(id: "14", title: "Bella Italia", cuisine: .italian),
            Restaurant(id: "15", title: "Sakura Sushi", cuisine: .japanese),
            Restaurant(id: "16", title: "Burger Bistro", cuisine: .american),
            Restaurant(id: "17", title: "La Dolce Vita", cuisine: .italian),
            Restaurant(id: "18", title: "Nihon Noodles", cuisine: .japanese),
            Restaurant(id: "19", title: "Patriot Burgers", cuisine: .american),
            Restaurant(id: "20", title: "Viva Pasta", cuisine: .italian),
            Restaurant(id: "21", title: "Zen Sushi", cuisine: .japanese)
        ]
    }
}

@MainActor
final class SearchableModifierViewModel: ObservableObject {
    @Published private(set) var allRestaurants: [Restaurant] = []
    @Published private(set) var filteredRestaurants: [Restaurant] = []
    @Published var searchText: String = ""
    @Published var searchScope: SearchScopeOption = .all
    @Published private(set) var allSearchScopes: [SearchScopeOption] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    let manager = RestaurantManager()
    
    enum SearchScopeOption: Hashable {
        case all
        case cuisines(option: CuisineOption)
        
        var title: String {
            switch self {
            case .all:
                return "All"
            case .cuisines(option: let option):
                return option.rawValue.capitalized
            }
        }
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        $searchText
            .combineLatest($searchScope)
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] (searchText, searchScope) in
                self?.filterRestaurants(searchText: searchText, currentSearchScope: searchScope)
            }
            .store(in: &cancellables)
    }
    
    private func filterRestaurants(searchText: String, currentSearchScope: SearchScopeOption) {
        guard !searchText.isEmpty else {
            filteredRestaurants = allRestaurants
            searchScope = .all
            return
        }
        
        // Filter on search scope
        var restaurantsInScope = allRestaurants
        switch currentSearchScope {
        case .all:
            break
        case .cuisines(option: let option):
            restaurantsInScope = allRestaurants.filter({ $0.cuisine == option })
        }
        
        // Filter on search text
        let search = searchText.lowercased()
        filteredRestaurants = restaurantsInScope.filter({ restaurant in
            let titleContainsSearch = restaurant.title.lowercased().contains(search)
            let cuisineContainsSearch = restaurant.cuisine.rawValue.lowercased().contains(search)
            return titleContainsSearch || cuisineContainsSearch
        })
    }
    
    func loadRestaurants() async {
        do {
            allRestaurants = try await manager.getAllRestaurants()
            
            let allCuisines = Set(allRestaurants.map { $0.cuisine })
            allSearchScopes = [.all] + allCuisines.map({ SearchScopeOption.cuisines(option: $0)})
        } catch {
            print(error)
        }
    }
    
    func getSearchSuggestions() -> [String] {
        var suggestions: [String] = []
        
        let search = searchText.lowercased()
        if search.contains("pa") {
            suggestions.append("Pasta")
        }
        if search.contains("su") {
            suggestions.append("Sushi")
        }
        if search.contains("bu") {
            suggestions.append("Burger")
        }
        suggestions.append("Market")
        suggestions.append("Grocery")
        
        suggestions.append(CuisineOption.american.rawValue)
        suggestions.append(CuisineOption.italian.rawValue)
        suggestions.append(CuisineOption.japanese.rawValue)
        
        return suggestions
    }
    
    func getRestaurantSuggestions() -> [Restaurant] {
            var suggestions: [Restaurant] = []
            
            let search = searchText.lowercased()
            if search.contains("ita") {
                suggestions.append(contentsOf: allRestaurants.filter({ $0.cuisine == .italian }))
            }
            if search.contains("jap") {
                suggestions.append(contentsOf: allRestaurants.filter({ $0.cuisine == .japanese }))
            }
            if search.contains("ame") {
                suggestions.append(contentsOf: allRestaurants.filter({ $0.cuisine == .american }))
            }
            
            return suggestions
    }
}

struct SearchableModifier: View {
    @StateObject private var viewModel = SearchableModifierViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(viewModel.filteredRestaurants) { restaurant in
                    NavigationLink(value: restaurant) {
                        restaurantRow(restaurant: restaurant)
                    }
                    .tint(.primary)
                }
            }
            .padding(.horizontal)
        }
        .searchable(text: $viewModel.searchText, placement: .automatic, prompt: Text("Search Restaurants..."))
        .searchScopes($viewModel.searchScope, scopes: {
            ForEach(viewModel.allSearchScopes, id: \.self) { scope in
                Text(scope.title)
                    .tag(scope)
            }
        })
        .searchSuggestions({
            ForEach(viewModel.getSearchSuggestions(), id: \.self) { suggestion in
                Text(suggestion)
                    .searchCompletion(suggestion)
            }
            ForEach(viewModel.getRestaurantSuggestions(), id: \.self) { suggestion in
                NavigationLink(value: suggestion) {
                    HStack {
                        Text(suggestion.title)
                        Spacer()
                        Image(systemName: "greaterthan")
                    }
                    .padding(.trailing)
                }
            }
        })
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Restaurants")
        .task {
            await viewModel.loadRestaurants()
        }
        .navigationDestination(for: Restaurant.self) { restaurant in
            Text(restaurant.title.uppercased())
        }
    }
    
    private func restaurantRow(restaurant: Restaurant) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(restaurant.title)
                .font(.headline)
            Text(restaurant.cuisine.rawValue.capitalized)
                .font(.caption)
        }
        .padding()
        .padding(.vertical, -4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.black.opacity(0.05))
    }
}

#Preview {
    NavigationStack {
        SearchableModifier()
    }
}
