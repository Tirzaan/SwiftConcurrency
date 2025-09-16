// Lesson 8
//
//  StructClassActor.swift
//  SwiftConcurrency
//
//  Created by Tirzaan on 9/12/25.
//

// Comments
/*
 
 Links
 /*
  https://blog.onewayfirst.com/ios/posts/2019-03-19-class-vs-struct/
  https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language
  https://medium.com/@vinayakkini/swift-basics-struct-vs-class-31b44ade28ae
  https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language/59219141#59219141
  https://stackoverflow.com/questions/27441456/swift-stack-and-heap-understanding
  https://stackoverflow.com/questions/24232799/why-choose-struct-over-class/24232845
  https://www.backblaze.com/blog/whats-the-diff-programs-processes-and-threads/
  https://medium.com/doyeona/automatic-reference-counting-in-swift-arc-weak-strong-unowned-925f802c1b99
  
  */
 
 Value vs. Reference Types
 /*
  VALUE TYPES:
  - Struct, Enum, String, Int, etc.
  - Stored in the Stack
  - Faster
  - Thread safe
  - When you assign or pass value types a new copy of the data is created
  
  REFERENCE TYPES:
  - Class, Functions, Actor
  - Stored in the Heap
  - Slower
  - Synchronized
  - NOT Thread safe, by default
  - When you assign or pass reference types a new reference to the original instance will be created (pointer)
  */
 
 Stack vs. Heap
 /*
  STACK:
  - Stores value types
  - Each thread has it's own stack
  - Variables allocated on the stack are stored directly to the memory, and access to this memory is vary fast
  
  HEAP:
  - Stores reference types
  - shared across threads
  
  */

 // Struct vs. Class vs. Actor
 /*
  STRUCT:
  - Based on VALUES
  - Can be mutated
  - Stored in the Stack
  
  CLASS:
  - Based on REFERENCES (INSTANCES)
  - Can NOT be mutated
  - Stored in the Heap
  - Inherit from other classes
  
  ACTOR:
  - Same as class but thread save
  
  */
 
 When to use Structs, Classes, Actors
 /*
  STRUCTS:
  - Data Models
  - Views
  
  CLASSES:
  - View Models
  
  ACTORS:
  - Shared 'Manager' and 'Data Store'
  
  */
 */

import SwiftUI

actor dataManager {
    
    func getDataFromDatabase() {
        
    }
    
}

class ViewModel: ObservableObject {
    @Published var title: String = ""
    
    init() {
        print("ViewModel Init")
    }
}

struct StructClassActor: View {
    
    @StateObject private var viewModel = ViewModel()
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
        print("View Init")
    }
    
    var body: some View {
        Text("Hello, World!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(isActive ? .red : .blue)
            .onAppear {
//                runTest()
            }
    }
}

struct StructClassActorHomeView: View {
    
    @State private var isActive: Bool = false
    
    var body: some View {
        StructClassActor(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
    
}

extension StructClassActor {
    private func runTest() {
        print("Test Started")
        print("")
        
        structTest1()
        printDivider()
        classTest1()
        printDivider()
        actorTest1()
        
        printDivider()
        
        structTest2()
        printDivider()
        classTest2()
    }
    
    private func printDivider() {
        print("""
        
        - - - - - - - - - - - - - - - - - - - - - - -
        
        """)
    }
}

//------------------------\\
//Struct

extension StructClassActor {
    private func structTest1() {
        print("STRUCT TEST 1")
        let objectA = MyStruct(title: "Starting Title")
        print("ObjectA: \(objectA.title)")
        
        print("Pass the VALUES of objectA to objectB")
        var objectB = objectA
        print("ObjectB: \(objectB.title)")
        
        objectB.title = "Second Title"
        print("ObjectB title changed!")
        
        print("ObjectA: \(objectA.title)")
        print("ObjectB: \(objectB.title)")
    }
    
    private func structTest2() {
        print("STRUCT TEST 2")
        
        var struct1 = MyStruct(title: "Title1")
        print("Struct1: \(struct1.title)")
        struct1.title = "Title2"
        print("Struct1: \(struct1.title)")
        
        var struct2 = CustomStruct(title: "Title1")
        print("Struct2: \(struct2.title)")
        struct2 = CustomStruct(title: "Struct2")
        print("Struct2: \(struct2.title)")
        
        
        var struct3 = CustomStruct(title: "Title1")
        print("Struct3: \(struct3.title)")
        struct3 = struct3.updateTitle(newTitle: "Title2")
        print("Struct3: \(struct3.title)")
        
        var struct4 = MutatingStruct(title: "Title1")
        print("Struct4: \(struct4.title)")
        struct4.updateTitle(newTitle: "Title2")
        print("Struct4: \(struct4.title)")
    }
}

struct MyStruct {
    var title: String
}

// Immutable struct
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
}

struct MutatingStruct {
    private(set) var title: String
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updateTitle(newTitle: String) {
        title = newTitle
    }

}

//------------------------\\
//Class

extension StructClassActor {
    private func classTest1() {
        print("CLASS TEST 1")
        let objectA = MyClass(title: "Starting Title")
        print("ObjectA: \(objectA.title)")
        
        print("Pass the REFERENCE of objectA to objectB")
        let objectB = objectA
        print("ObjectB: \(objectB.title)")
        
        objectB.title = "Second Title"
        print("ObjectB title changed!")
        
        print("ObjectA: \(objectA.title)")
        print("ObjectB: \(objectB.title)")
    }
    
    private func classTest2() {
        print("CLASS TEST 2")
        
        let class1 = MyClass(title: "Title1")
        print("Class1: \(class1.title)")
        class1.title = "Title2"
        print("Class1: \(class1.title)")
        
        let class2 = MyClass(title: "Title1")
        print("Class2: \(class2.title)")
        class2.updateTitle(newTitle: "Title2")
        print("Class2: \(class2.title)")

    }
}

class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

//------------------------\\
//Actor

extension StructClassActor {
    private func actorTest1() {
        Task {
            print("ACTOR TEST 1")
            let objectA = MyActor(title: "Starting Title")
            await print("ObjectA: \(objectA.title)")
            
            print("Pass the REFERENCE of objectA to objectB")
            let objectB = objectA
            await print("ObjectB: \(objectB.title)")
            
            await objectB.updateTitle(newTitle: "Second Title")
            print("ObjectB title changed!")
            
            await print("ObjectA: \(objectA.title)")
            await print("ObjectB: \(objectB.title)")
        }
    }
}

actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

#Preview {
    StructClassActor(isActive: true)
}

