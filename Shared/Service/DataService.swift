//
//  DataService.swift
//  ChatGPT (iOS)
//
//  Created by peak on 2023/2/20.
//

import Foundation

protocol DataService {
    
    func getData(from path: URL) -> Data?
    
    func saveData(data: Data?, at path: URL)
}

extension DataService {
    
    func getData(from path: URL) -> Data? {
        do {
            let data = try Data(contentsOf: path)
            return data
        } catch {
            print("get data occur error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveData(data: Data?, at path: URL) {
        if let data = data {
            do {
                try data.write(to: path, options: [.atomic])
            } catch {
                print("save data occur error: \(error.localizedDescription)")
            }
        }
    }
}
