// Lesson 12
//
//  AsyncPubisher.swift
//  SwiftConcurrency
//
//  Created by Tirzaan on 9/20/25.
//

import SwiftUI

actor AsyncPubisherDataManager {
    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(for: .seconds(2))
        myData.append("Banana")
        try? await Task.sleep(for: .seconds(2))
        myData.append("Orange")
        try? await Task.sleep(for: .seconds(2))
        myData.append("Watermelon")
    }
}

class AsyncPubisherViewModel: ObservableObject {
    @MainActor @Published var dataArray: [String] = []
    let manager = AsyncPubisherDataManager()
    
    init() {
        addSubscibers()
    }
    
    func addSubscibers() {
        Task {
//            await MainActor.run {
//                self.dataArray = ["One"]
//            }
            
            for await value in await manager.$myData.values { // Task is stuck here forever until return/break
                await MainActor.run {
                    self.dataArray = value
                    
                }
            }
            
//            await MainActor.run { // WILL NEVER RUN
//                self.dataArray = ["Two"]
//            }
        }
    }
    
    func start() async {
        await manager.addData()
    }
}

struct AsyncPublishers: View {
    @StateObject private var viewModel = AsyncPubisherViewModel()
    
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
            await viewModel.start()
        }
    }
}

#Preview {
    AsyncPublishers()
}
