//
//  APIConfig.swift
//  ChatGPT (iOS)
//
//  Created by peak on 2023/2/20.
//

import Foundation

struct APIConfig {
    let apiKey: String
    let model: String
    let stream: Bool
    let temperature: Double
    let basePrompt: String
    let maxToken = 1024
    
    let stop: [String] = [
        "\n\n\n",
        "<|im_end|>"
    ]
    let urlString: String = "https://api.openai.com/v1/completions"
    let method = "POST"
    
    var headers: [String: String] {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
    }
}
