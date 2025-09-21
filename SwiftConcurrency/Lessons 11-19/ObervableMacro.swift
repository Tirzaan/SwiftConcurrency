// Lesson 19
//
//  ObervableMacro.swift
//  SwiftConcurrency
//
//  Created by Tirzaan on 9/20/25.
//

import SwiftUI

actor TitleDatabase {
    func getNewTitle() -> String {
        "Updated Title"
    }
}

@MainActor
@Observable class ObservableMacroViewModel {
    @ObservationIgnored let database = TitleDatabase()
    var title: String = "Starting Title"
    
    func updateTitle() async {
        title = await database.getNewTitle()
        print(Thread.current)
    }
}

struct ObservableMacro: View {
    @State private var viewModel = ObservableMacroViewModel()
    
    var body: some View {
        Text(viewModel.title)
            .task {
                await viewModel.updateTitle()
            }
    }
}

#Preview {
    ObservableMacro()
}
