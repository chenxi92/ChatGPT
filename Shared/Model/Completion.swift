//
//  Completion.swift
//  ChatGPT (iOS)
//
//  Created by peak on 2023/2/20.
//

import Foundation

public struct Completion: Decodable {
    /// The unique identifier for the completion.
    public let id: String
    
    public let choices: [Choice]
}

public struct Choice: Decodable {
    /// The text of the completion choice.
    public let text: String
}
