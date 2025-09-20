// Lesson 14
//
//  MVVM.swift
//  SwiftConcurrency
//
//  Created by Tirzaan on 9/20/25.
//

import SwiftUI

final class MVVMManagerClass {
    func getData() async throws -> String {
        "Some Data"
    }
}

actor MVVMManagerActor {
    func getData() async throws -> String {
        "Some Data"
    }
}

@MainActor
final class MVVMViewModel: ObservableObject {
    let managerClass = MVVMManagerClass()
    let managerActor = MVVMManagerActor()
    
    /*@MainActor*/ @Published private(set) var myData: String = "Starting Text"
    private var tasks: [Task<(), Never>] = []
    
    func cancelAllTasks() {
        tasks.forEach({ $0.cancel() })
        tasks = []
    }
    
    func onCallToActionButtonPressed() {
        let task = Task { /*@MainActor in*/
            do {
//                myData = try await managerClass.getData()
                myData = try await managerActor.getData()
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
}

struct MVVM: View {
    @StateObject private var viewModel = MVVMViewModel()
    
    var body: some View {
        VStack {
            Button("Click Me") {
                viewModel.onCallToActionButtonPressed()
            }
            
            Button("") {
                
            }
        }
        .onDisappear {
            
        }
    }
}

#Preview {
    MVVM()
}
