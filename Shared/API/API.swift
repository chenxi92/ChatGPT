//
//  API.swift
//  ChatGPT
//
//  Created by peak on 2023/2/17.
//

import Foundation
import os

class API {
    private var histories: [String] = []
    private let urlSession = URLSession.shared
    private let logger: Logger = Logger(subsystem: "ChatGPT", category: "API")
    
    var config: APIConfig
    
    init(config: APIConfig) {
        self.config = config
    }
    
    // MARK: - Public
    
    public func askGPT(text: String) async throws -> AsyncThrowingStream<String, Error> {
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try jsonBody(text: text)
        
        let (result, response) = try await urlSession.bytes(for: urlRequest)
                
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("Invalid http response")
            throw "Invalid response"
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            logger.error("Bad Response: \(httpResponse.statusCode)")
            throw "Bad Response: \(httpResponse.statusCode)"
        }
        
        return AsyncThrowingStream<String, Error> { continuation in
            Task(priority: .userInitiated) {
                do {
                    var responseText = ""
                    for try await line in result.lines {
                        if line.hasPrefix("data: "),
                           let data = line.dropFirst(6).data(using: .utf8),
                           let response = try? JSONDecoder().decode(Completion.self, from: data),
                           let text = response.choices.first?.text {
                            responseText += text
                            continuation.yield(text)
                        }
                    }
                    
                    self.appendToHistoryList(userText: text, responseText: responseText)
                    continuation.finish()
                } catch {
                    logger.error("error: \(error.localizedDescription)")
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func appendToHistoryList(userText: String, responseText: String) {
        let text = "User: \(userText)\n\n\nChatGPT: \(responseText)<|im_end|>\n"
        self.histories.append(text)
    }
    
    private func jsonBody(text: String) throws -> Data {
        let jsonBody: [String: Any] = [
            "model": config.model,
            "temperature": config.temperature,
            "max_tokens": config.maxToken,
            "prompt": generateChatGPTPrompt(from: text),
            "stop": config.stop,
            "stream": config.stream
        ]
        return try JSONSerialization.data(withJSONObject: jsonBody)
    }
    
    private func generateChatGPTPrompt(from text: String) -> String {
        var prompt = config.basePrompt + historyListText + "User: \(text)\nChatGPT:"
        if prompt.count > (4000 * 4) {
            _ = histories.dropFirst()
            prompt = generateChatGPTPrompt(from: text)
        }
        return prompt
    }
    
    // MARK: - Readonly
    
    var historyListText: String {
        return histories.joined()
    }
    
    var urlRequest: URLRequest {
        let url = URL(string: config.urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = config.method
        config.headers.forEach{ urlRequest.setValue($1, forHTTPHeaderField: $0) }
        return urlRequest
    }
}


extension String: CustomNSError {
    public var errorUserInfo: [String : Any] {
        [
            NSLocalizedDescriptionKey: self
        ]
    }
}

