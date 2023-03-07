//
//  AboutView.swift
//  ChatGPT (macOS)
//
//  Created by peak on 2023/2/21.
//

import SwiftUI

struct AboutView: View {
    
    let repositoryURL: URL = URL(string: "https://github.com/chenxi92/ChatGPT")!
    
    var body: some View {
        VStack(spacing: 10) {
            Image(nsImage: NSImage(named: "AppIcon")!)
                .clipShape(Circle())
                .padding()
            
            Text("\(Bundle.main.appName)")
                .font(.title.bold())
            
            Text("Version: \(Bundle.main.appVersion) (\(Bundle.main.appBuildVersion)) ")
                .foregroundColor(.secondary)
            
            Text("Author: ChenXi")
                .font(.body)
            
            Link("Source Code", destination: repositoryURL)
            
            Text(Bundle.main.copyright)
        }
        .frame(minWidth: 300, maxWidth: 300)
        .font(.body)
        .padding()
    }
}

extension Bundle {
    public var appName: String {
        getInfo("CFBundleName")
    }
    
    public var appBuildVersion: String {
        getInfo("CFBundleVersion")
    }
    
    public var appVersion: String {
        getInfo("CFBundleShortVersionString")
    }
    
    public var copyright: String {
        getInfo("NSHumanReadableCopyright")
    }
    
    fileprivate func getInfo(_ key: String) -> String {
        infoDictionary?[key] as? String ?? ""
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
