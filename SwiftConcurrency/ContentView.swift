//
//  ContentView.swift
//  SwiftConcurrency
//
//  Created by Tirzaan on 9/4/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Lesson 1 - Do, Catch, Try, Throws") { DoCatchTryThrows() }
                NavigationLink("Lesson 2 - Download Images w/ async") { DownloadImageAsync() }
                NavigationLink("Lesson 3 - Async/Await") { AsyncAwait() }
            }
            .navigationTitle("Lessons")
        }
    }
}

#Preview {
    ContentView()
}
