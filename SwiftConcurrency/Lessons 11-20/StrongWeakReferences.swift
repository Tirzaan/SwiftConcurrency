// Lesson 13
//
//  StrongWeakReferences.swift
//  SwiftConcurrency
//
//  Created by Tirzaan on 9/20/25.
//

import SwiftUI

final class StrongWeakReferencesDataService {
    
    func getData() async -> String {
        "Updated Data"
    }
    
}

final class StrongWeakReferencesViewModel: ObservableObject {
    @Published var data: String = "Some Title"
    let dataService = StrongWeakReferencesDataService()
    private var someTask: Task<Void, Never>? = nil
    private var myTasks: [Task<Void, Never>] = []

    
    func cancelTasks() {
        someTask?.cancel()
        someTask = nil
        
        myTasks.forEach({ $0.cancel() })
        myTasks = []
    }
    
    // This implies a strong reference.
    func updateData() {
        Task {
            data = await dataService.getData()
        }
    }
    
    // This is a strong reference.
    func strongUpdateData() {
        Task {
            self.data = await self.dataService.getData()
        }
    }
    
    // This is a strong reference.
    func strongUpdateData2() {
        Task { [self] in
            self.data = await self.dataService.getData()
        }
    }
    
    // This is a weak reference.
    func weakUpdateData() {
        Task { [weak self] in
            if let data = await self?.dataService.getData() {
                self?.data = data
            }
        }
    }
    
    // We don't need to manage weak/strong
    // Because we can manage the task!
    func weakUpdateData2() {
        someTask = Task {
            self.data = await self.dataService.getData()
        }
    }
    
    // We can manage the task!
    func weakUpdateData3() {
        let task1 = Task {
            self.data = await self.dataService.getData()
        }
        myTasks.append(task1)
        
        let task2 = Task {
            self.data = await self.dataService.getData()
        }
        myTasks.append(task2)
    }
    
    // We purposely do not cancel tasks to keep strong references
    func weakUpdateData4() {
        Task {
            self.data = await self.dataService.getData()
        }
        
        Task.detached {
            self.data = await self.dataService.getData()
        }
    }
    
    func asyncUpdateData() async {
        Task {
            self.data = await self.dataService.getData()
        }
    }
}

struct StrongWeakReferences: View {
    
    @StateObject private var viewModel = StrongWeakReferencesViewModel()
    
    var body: some View {
        Text(viewModel.data)
            .onAppear {
                viewModel.updateData()
            }
            .onDisappear {
                viewModel.cancelTasks()
            }
            .task {
                await viewModel.asyncUpdateData()
            }
    }
}

#Preview {
    StrongWeakReferences()
}
