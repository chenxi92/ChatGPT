//
//  DataService.swift
//  ChatGPT (iOS)
//
//  Created by peak on 2023/2/20.
//

import Foundation

protocol DataService {
    
    var dataURL: URL { get }
    
    func getData() -> Data?
    
    func saveData(data: Data?)
    
    func clear()
}

extension DataService {
    
    func getData() -> Data? {
        do {
            return try Data(contentsOf: dataURL)
        } catch {
            print("get data occur error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveData(data: Data?) {
        if let data = data {
            do {
                try data.write(to: dataURL, options: [.atomic])
            } catch {
                print("save data occur error: \(error.localizedDescription)")
            }
        }
    }
    
    func clear() {
        do {
            try FileManager.default.removeItem(at: dataURL)
        } catch {
            
        }
    }
}
