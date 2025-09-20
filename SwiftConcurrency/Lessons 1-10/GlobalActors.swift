// Lesson 10
//
//  GlobalActors.swift
//  SwiftConcurrency
//
//  Created by Tirzaan on 9/19/25.
//

import SwiftUI

// final = no other class can inheit from this one
// Can be class or struct (do not put 'final' if using struct)
@globalActor final class MyFirstGlobalActor {
    
    static var shared = MyNewDataManager()
    
}

actor MyNewDataManager {
    func getDataFromDatabase() -> [String] {
        return ["One", "Two", "Three", "Four", "Five", "Six"]
    }
}

// @MainActor = MAKES WHOLE CLASS '@MainActor'
class GlobalActorsViewModel: ObservableObject {
    @MainActor @Published var dataArray: [String] = []
    let manager = MyFirstGlobalActor.shared
    
    @MyFirstGlobalActor func getData() async {
        
        // HEAVY COMPLEX METHODS
        
        Task {
            let data = await manager.getDataFromDatabase()
            await MainActor.run {
                self.dataArray = data
            }
        }
    }
}

struct GlobalActors: View {
    @StateObject private var viewModel = GlobalActorsViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) { data in
                    Text(data)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.getData()
        }
    }
}

#Preview {
    GlobalActors()
}
