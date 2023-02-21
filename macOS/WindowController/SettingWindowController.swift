//
//  SettingWindowController.swift
//  ChatGPT (macOS)
//
//  Created by peak on 2023/2/21.
//

import SwiftUI

class SettingWindowController: BaseWindowController {
        
    override class func Create<T: ObservableObject>(viewModel: T) -> SettingWindowController {
        let window = NSWindow()
        window.center()
        
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        window.title = "ChatGPT"
        
        let vc = SettingWindowController(window: window)
        
        let rootView = SettingView()
            .frame(minWidth: 500,
                   idealWidth: 550,
                   maxWidth: .infinity,
                   minHeight: 400,
                   maxHeight: .infinity)
            .environmentObject(viewModel)
        vc.contentViewController = NSHostingController(rootView: rootView)
        
        return vc
    }
}
