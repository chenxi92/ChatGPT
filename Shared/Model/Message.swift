//
//  Message.swift
//  ChatGPT
//
//  Created by peak on 2023/2/17.
//

import SwiftUI

public struct Message: Identifiable, Codable {
    public var id = UUID()
    
    var isInteractingWithChatGPT: Bool
    
    let sendImage: String
    let sendImageData: Data?
    let sendText: String
    
    let responseImage: String
    var responseText: String
    
    var responseError: String?
}

extension Message {
    static func Sender(text: String, response: String = "", sendImageData: Data? = nil) -> Message {
        Message(
            isInteractingWithChatGPT: true,
            sendImage: "person",
            sendImageData: sendImageData,
            sendText: text,
            responseImage: "openai",
            responseText: response,
            responseError: nil)
    }
}

extension Message {
    static let testNormal = Message(
        isInteractingWithChatGPT: true,
        sendImage: "person",
        sendImageData: nil,
        sendText: "What is SwiftUI?",
        responseImage: "openai",
        responseText: "SwiftUI is a user interface framework that allows developers to design and develop user interfaces for iOS, macOS, watchOS, and tvOS applications using Swift, a programming language developed by [Apple Inc](https://apple.com).")
    
    static let testNormal2 = Message(
        isInteractingWithChatGPT: false,
        sendImage: "person",
        sendImageData: nil,
        sendText: "What is SwiftUI?",
        responseImage: "openai",
        responseText: """
**SwiftUI** is a user `interface framework` that allows developers to design and develop user interfaces for: `iOS`, `macOS`, `watchOS`, `tvOS` applications using Swift, a programming language developed by [Apple Inc](https://apple.com).

Some code example like this:


```swift
struct Content: View {
    var body: some View {
        VStack(spacing: 0) {

            RequestRow()

            Divider()

            ResponseView()

            Divider()
        }
        .textSelection(.enabled)
    }
}
```


There is a dog image ![image](https://images.dog.ceo/breeds/schnauzer-miniature/n02097047_2409.jpg)
""")
    
    static let testError = Message(
        isInteractingWithChatGPT: false,
        sendImage: "person",
        sendImageData: nil,
        sendText: "What is SwiftUI?",
        responseImage: "openai",
        responseText: "",
        responseError: "ChatGPT is currently not available")
}
