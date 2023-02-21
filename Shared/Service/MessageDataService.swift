//
//  MessageDataService.swift
//  ChatGPT (iOS)
//
//  Created by peak on 2023/2/20.
//

import Foundation

struct MessageDataService: DataService {
    private let fileName = "messages"
    
    func getData() -> Data? {
        let url = messageDataURL()
        guard FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return getData(from: url)
    }

    func saveData(data: Data?) {
        saveData(data: data, at: messageDataURL())
    }
    
    func clear() {
        do {
            try FileManager.default.removeItem(at: messageDataURL())
        } catch {
        }
    }
    
    private func messageDataURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var documentURL = paths[0]
        documentURL.appendPathComponent(fileName)
        return documentURL
    }
}
