//
//  AboutWindowController.swift
//  ChatGPT (macOS)
//
//  Created by peak on 2023/2/21.
//

import SwiftUI

class AboutWindowController: BaseWindowController {
        
    override class func Create<T: ObservableObject>(viewModel: T) -> AboutWindowController {
        let window = NSWindow()
        window.center()
        
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        window.title = "About"
        
        let vc = AboutWindowController(window: window)
        
        let rootView = AboutView()
            .frame(minWidth: 400,
                   idealWidth: 500,
                   maxWidth: .infinity,
                   minHeight: 400,
                   maxHeight: .infinity)
        vc.contentViewController = NSHostingController(rootView: rootView)
        
        return vc
    }
}
