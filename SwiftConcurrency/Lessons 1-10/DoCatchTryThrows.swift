//
//  DoCatchTryThrows.swift
//  SwiftConcurrency
//
//  Created by Tirzaan on 9/4/25.
//

import SwiftUI

// do-catch
// try
// throws

class DoCatchTryThrowsDataManager {
    
    let isAcitve: Bool = true
    
    func getTitle() -> (title: String?, error: Error?) {
        if isAcitve {
            return ("New Text!", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isAcitve {
            return .success("New Text!")
        } else {
            return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
        }
    }
    
    func getTitle3() throws -> String {
//        if isAcitve {
//            return "New Text!"
//        } else {
            throw URLError(.badServerResponse)
//        }
    }
    
    func getTitle4() throws -> String {
        if isAcitve {
            return "Final Text!"
        } else {
            throw URLError(.badServerResponse)
        }
    }
}

class DoCatchTryThrowsViewModel: ObservableObject {
    
    @Published var text = "Starting Test"
    let manager = DoCatchTryThrowsDataManager()
    
    
    func fetchTitle() {
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            self.text = newTitle
        } else if let error = returnedValue.error {
            self.text = error.localizedDescription
        }
    }
    
    func fetchTitle2() {
        let result = manager.getTitle2()
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
    }
    
    func fetchTitle3() {
        do {
            let newTitle = try manager.getTitle3()
            self.text = newTitle
        } catch /*let error*/ {
            self.text = error.localizedDescription
        }
    }
    
    func fetchTitle4() {
        
//        let newTitle = try? manager.getTitle3()
//        if let newTitle = newTitle {
//            self.text = newTitle
//        }
        
        do {
            let newTitle = try? manager.getTitle3()
            if let newTitle = newTitle {
                self.text = newTitle
            }
            
            let finalText = try manager.getTitle4()
            self.text = finalText
        } catch /*let error*/ {
            self.text = error.localizedDescription
        }
    }
}

struct DoCatchTryThrows: View {
    
    @StateObject private var viewModel = DoCatchTryThrowsViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitle4()
            }
    }
}

#Preview {
    DoCatchTryThrows()
}
