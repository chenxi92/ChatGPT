//
//  ProfileView.swift
//  ChatGPT
//
//  Created by peak on 2023/2/17.
//

import SwiftUI

struct ProfileView: View {
    
    let name: String?
    let systemName: String?
    let urlString: String?
    let data: Data?
    
    init(name: String? = nil, systemName: String? = nil, urlString: String? = nil, data: Data? = nil) {
        self.name = name
        self.systemName = systemName
        self.urlString = urlString
        self.data = data
    }
    
    var body: some View {
        if let data = data, let kImage = kImage(data: data) {
            kImage
                .toImage()
                .resizeToCircle()
        } else if let systemName = systemName {
            Image(systemName: systemName)
                .resizeToCircle()
        } else if let urlString = urlString, let url = URL(string: urlString) {
            
            AsyncImage(url: url) { image in
                image
                    .resizeToCircle()
            } placeholder: {
                ProgressView()
            }
        } else if let name = name {
            Image(name)
                .resizeToCircle()
        } else {
            EmptyView()
        }
    }
}

extension Image {
    
    func resizeToCircle() -> some View {
        self
            .resizable()
            .frame(width: imageSize.width,
                   height: imageSize.height)
            .clipShape(Circle())
    }
    
    var imageSize: CGSize {
        #if os(macOS)
        CGSize(width: 20, height: 20)
        #else
        CGSize(width: 25, height: 25)
        #endif
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ProfileView(systemName: "person")
            ProfileView(name: "openai")
            ProfileView(urlString: "https://cdn-icons-png.flaticon.com/128/9702/9702869.png")
        }
    }
}
