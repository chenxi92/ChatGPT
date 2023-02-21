//
//  AppDelegate.swift
//  ChatGPT (macOS)
//
//  Created by peak on 2023/2/20.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    @Published var statusItem: NSStatusItem?
    
    static var vm: ViewModel = .init()
    
    private var mainVC: MainWindowController?
    private var settingVC: SettingWindowController?
    private var aboutVC: AboutWindowController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        guard let button = statusItem?.button else {
            return
        }
        let image = NSImage(named: "menu-bar")
        image?.size = NSSize(width: 18, height: 18)
        image?.resizingMode = .stretch
        
        button.image = image
        button.target = self;
        button.action = #selector(showMenu(_:))
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }
    
    @objc
    private func showMenu(_ sender: AnyObject?) {
        switch NSApp.currentEvent?.type {
        case .leftMouseUp:
            showMainWindow()
        case .rightMouseUp:
            showSecondaryMenu()
        default:
            break
        }
    }
    
    private func showMainWindow() {
        if mainVC == nil {
            mainVC = MainWindowController.Create(viewModel: AppDelegate.vm)
            mainVC?.onWindowClose = { [weak self] in
                self?.mainVC = nil
            }
        }
        mainVC?.showWindow(self)
    }
    
    func showSecondaryMenu() {
        let menu = NSMenu()
        
        addItem("Preferences...", action: #selector(showPreferences), key: "p", to: menu)
        addItem("About...", action: #selector(showAbout), key: "c", to: menu)
        menu.addItem(NSMenuItem.separator())
        addItem("Quit", action: #selector(quit), key: "q", to: menu)
        
        showStatusItemMenu(menu)
    }
    
    private func showStatusItemMenu(_ menu: NSMenu) {
        statusItem?.menu = menu
        statusItem?.button?.performClick(nil)
        statusItem?.menu = nil
    }
    
    private func addItem(_ title: String, action: Selector?, key: String, to menu: NSMenu) {
        let item = NSMenuItem()
        item.title = title
        item.target = self
        item.action = action
        item.keyEquivalent = key
        menu.addItem(item)
    }
    
    // MARK: - Actions
    
    @objc
    func showPreferences() {
        if settingVC == nil {
            settingVC = SettingWindowController.Create(viewModel: AppDelegate.vm)
            settingVC?.onWindowClose = { [weak self] in
                self?.settingVC = nil
            }
        }
        settingVC?.showWindow(self)
    }
    
    @objc
    func showAbout() {
        if aboutVC == nil {
            aboutVC = AboutWindowController.Create(viewModel: AppDelegate.vm)
            aboutVC?.onWindowClose = { [weak self] in
                self?.aboutVC = nil
            }
        }
        aboutVC?.showWindow(self)
    }
    
    @objc
    func quit() {
        NSApp.terminate(self)
    }
}

