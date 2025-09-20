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
                NavigationLink("Lesson 4 - Tasks") { Tasks() }
                NavigationLink("Lesson 5 - Async Let") { AsyncLet() }
                NavigationLink("Lesson 6 - Task Groups") { TaskGroups() }
                NavigationLink("Lesson 7 - Checked Coninuation") { CheckedConinuation() }
                NavigationLink("Lesson 8 - Struct, Class, Actor") { StructClassActorHomeView() }
                NavigationLink("Lesson 9 - Actors") { Actors() }
                NavigationLink("Lesson 10 - Global Actors") { GlobalActors() }
                NavigationLink("Lesson 11 - Sendable") { SendableProtocol() }
                NavigationLink("Lesson 12 - Async Publisher") { AsyncPublishers() }
                NavigationLink("Lesson 13 - Strong/Weak References") { StrongWeakReferences() }
                NavigationLink("Lesson 14 - MVVM") { MVVM() }
                NavigationLink("Lesson 15 - Refreshable") { RefreshableModifier() }
                NavigationLink("Lesson 16 - Something") { Text("Nothing Here Yet") }
                NavigationLink("Lesson 17 - Something") { Text("Nothing Here Yet") }
                NavigationLink("Lesson 18 - Something") { Text("Nothing Here Yet") }
                NavigationLink("Lesson 19 - Something") { Text("Nothing Here Yet") }
                NavigationLink("Lesson 20 - Something") { Text("Nothing Here Yet") }
            }
            .navigationTitle("Lessons")
        }
    }
}

#Preview {
    ContentView()
}
