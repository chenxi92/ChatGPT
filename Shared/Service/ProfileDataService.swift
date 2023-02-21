//
//  ProfileDataService.swift
//  ChatGPT (iOS)
//
//  Created by peak on 2023/2/20.
//

import Foundation

struct ProfileDataService: DataService {
    
    private let fileName = "localProfileImage.png"
    
    func getData() -> Data? {
        let url = profileImageURL()
        guard FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return getData(from: url)
    }

    func saveData(data: Data?) {
        saveData(data: data, at: profileImageURL())
    }
    
    private func profileImageURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var documentURL = paths[0]
        documentURL.appendPathComponent(fileName)
        return documentURL
    }
}
