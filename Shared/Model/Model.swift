//
//  Model.swift
//  ChatGPT
//
//  Created by peak on 2023/2/23.
//

import Foundation

public struct Model {
    
}

extension Model {
    public enum GPT3: String, CaseIterable, Identifiable {
        case textDavinci003 = "text-davinci-003"
        case textDavinci002 = "text-davinci-002"
        case textCurie001 = "text-curie-001"
        case textBabbage001 = "text-babbage-001"
        case textAda001 = "text-ada-001"
        case textEmbeddingAda001 = "text-embedding-ada-002"
        case textDavinci001 = "text-davinci-001"
        case textDavinciEdit001 = "text-davinci-edit-001"
        case davinciInstructBeta = "davinci-instruct-beta"
        case curieInstructBeta = "curie-instruct-beta"
        
        public var id: String {
            rawValue
        }
    }
}
