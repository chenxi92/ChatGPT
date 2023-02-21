//
//  ProfileDataService.swift
//  ChatGPT (iOS)
//
//  Created by peak on 2023/2/20.
//

import Foundation

struct ProfileDataService: DataService {
    
    private let fileName = "localProfileImage.png"
    
    var dataURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var documentURL = paths[0]
        documentURL.appendPathComponent(fileName)
        return documentURL
    }
}
