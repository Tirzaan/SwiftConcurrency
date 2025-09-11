// Lesson 4
//
//  Tasks.swift
//  SwiftConcurrency
//
//  Created by Tirzaan on 9/11/25.
//

import SwiftUI

class TasksViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        try? await Task.sleep(for: .seconds(5))
        // For bigger things use "try Task.checkCancellation"
        
        do {
            guard let url = URL(string: "https://picsum.photos/2000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            
            await MainActor.run {
                self.image = UIImage(data: data)
                print("Image Retrieved")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/2000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            
            await MainActor.run {
                self.image2 = UIImage(data: data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct Tasks: View {
    
    @StateObject private var viewModel = TasksViewModel()
//    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            } else {
                ProgressView()
            }
            
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            } else {
                ProgressView()
            }
        }
        .task {
            await viewModel.fetchImage()
        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
//        .onAppear {
//            fetchImageTask = Task {
//                await viewModel.fetchImage()
//            }
////            Task {
////                await viewModel.fetchImage2()
////            }
//            
//            // HIGH 25
////            Task(priority: .high) {
////                await Task.yield()
////                print("HIGH: \(Thread.current): \(Task.currentPriority)/\(Task.currentPriority.rawValue)")
////            }
////            Task(priority: .userInitiated) {
////                print("USER INITIAITED: \(Thread.current): \(Task.currentPriority)/\(Task.currentPriority.rawValue)")
////            }
//            
//            // MEDIUM 21
////            Task(priority: .medium) {
////                print("MEDIUM: \(Thread.current): \(Task.currentPriority)/\(Task.currentPriority.rawValue)")
////            }
//            
//            // LOW 17
////            Task(priority: .low) {
////                print("LOW: \(Thread.current): \(Task.currentPriority)/\(Task.currentPriority.rawValue)")
////            }
////            Task(priority: .utility) {
////                print("UTILITY: \(Thread.current): \(Task.currentPriority)/\(Task.currentPriority.rawValue)")
////            }
//            
//            // BACKGROUND 9
////            Task(priority: .background) {
////                print("BACKGROUND: \(Thread.current): \(Task.currentPriority)/\(Task.currentPriority.rawValue)")
////            }
////
//            
//            //CHILD TASKS
////            Task(priority: .userInitiated) {
////                print("USER INITIAITED: \(Thread.current): \(Task.currentPriority)/\(Task.currentPriority.rawValue)")
////                
////                Task.detached {
////                    print("DETACHED: \(Thread.current): \(Task.currentPriority)/\(Task.currentPriority.rawValue)")
////                }
////            }
//        }
    }
}

#Preview {
    Tasks()
}
