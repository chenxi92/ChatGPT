//
//  ChatGPTMac.swift
//  ChatGPT (macOS)
//
//  Created by peak on 2023/2/20.
//

import SwiftUI

@main
struct ChatGPTMac: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            EmptyView()
                .frame(width: 0.1, height: 0.1)
                .hidden()
        }
    }
}


