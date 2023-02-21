//
//  ChatGPTApp.swift
//  Shared
//
//  Created by peak on 2023/2/17.
//

import SwiftUI

@main
struct ChatGPTApp: App {
    init() {
        UINavigationBar.appearance().backgroundColor = .systemBackground
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ViewModel())
        }
    }
}
