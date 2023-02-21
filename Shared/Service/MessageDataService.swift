//
//  MessageDataService.swift
//  ChatGPT (iOS)
//
//  Created by peak on 2023/2/20.
//

import Foundation

struct MessageDataService: DataService {
    private let fileName = "messages"
    
    var dataURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var documentURL = paths[0]
        documentURL.appendPathComponent(fileName)
        return documentURL
    }
}
