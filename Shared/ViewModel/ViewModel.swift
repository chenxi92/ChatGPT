//
//  ViewModel.swift
//  ChatGPT
//
//  Created by peak on 2023/2/17.
//

import Foundation
import SwiftUI
import AVKit
import os

class ViewModel: ObservableObject {
    
    // MARK: API Setting
    
    @AppStorage("APISetting.apiKey") var apiKey: String = ""
    
    @AppStorage("APISetting.model")
    var model: String = "text-davinci-003"
    
    @AppStorage("APISetting.temperature")
    var temperature = 0.5
    
    @AppStorage("APISetting.tream")
    var stream = true
    
    @AppStorage("APISettting.basePrompt")
    var basePrompt: String =
        "You are ChatGPT, a large language model trained by OpenAI. Respond conversationally. Do not answer as the user. Current date: \(dateFormatter.string(from: Date()))"
        + "\n"
        + "User: Hello\n"
        + "ChatGPT: Hello! How can I help you today? <|im_end|>\n"
    
    // MARK: Common Setting
    
    @AppStorage("isSaveHistory") var isSaveHistory: Bool = false
    @AppStorage("isEnableSynthesizer") var isEnableSynthesizer: Bool = false {
        didSet {
            if isEnableSynthesizer {
                synthesizer = .init()
            } else {
                synthesizer = nil
            }
        }
    }
    @AppStorage("language") var language = Language.zh.tag
    
    // MARK: - Published
    
    /// Custom profile image data, selected from photo library.
    @Published var imageData: Data? = nil
    
    @Published var isInteractingWithChatGPT = false
    @Published var messages: [Message] = []
    @Published var inputMessage: String = ""
    @Published var isShowError: Bool = false
    @Published var errorMessage: String = ""
    
    // MARK: - Private
    
    private var api: API? = nil
    
    private var profileService = ProfileDataService()
    
    private var synthesizer: AVSpeechSynthesizer?
    
    private var logger: Logger = .init(subsystem: "ChatGPT", category: "ViewModel")
    
    public var isEmptyInput: Bool {
        return inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - LifeCircle
    init () {
        logger.info("[\(#fileID)] init.")
        
        imageData = profileService.getData()
        
        fetchMessageData()
    }
    
    // MARK: - Public
    
    @MainActor
    public func reset() {
        inputMessage = ""
        errorMessage = ""
        isShowError = false
        logger.info("reset data")
    }
    
    @MainActor
    func sendTapped() async {
        let text = inputMessage
        inputMessage = ""
        await send(text: text)
    }
    
    @MainActor
    func retry(message: Message) async {
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else {
            return
        }
        self.messages.remove(at: index)
        await send(text: message.sendText)
    }
    
    // MARK: - Private
    
    @MainActor
    private func send(text: String) async {
        if buildAPI() == false {
            return
        }
        
        guard let api = self.api else {
            return
        }
        
        isInteractingWithChatGPT = true
        var streamText = ""
        var message = Message.Sender(text: text, sendImageData: imageData)
        logger.debug("request text: [\(message.sendText)]")
        self.messages.append(message)
        
        do {
            let stream = try await api.askGPT(text: text)
            for try await text in stream {
                streamText += text
                message.responseText = streamText.trimmingCharacters(in: .whitespacesAndNewlines)
                self.messages[self.messages.count - 1] = message
            }
        } catch {
            message.responseError = error.localizedDescription
        }
        
        if let responseError = message.responseError {
            logger.error("response error: \(responseError)")
        } else {
            logger.debug("response: \(message.responseText)")
        }
        message.isInteractingWithChatGPT = false
        self.messages[self.messages.count - 1] = message
        isInteractingWithChatGPT = false
        
        self.saveMessageData()
        
        speakLastResponse()
    }
    
    private func buildAPI() -> Bool {
        guard !apiKey.isEmpty else {
            errorMessage = "No API KEY"
            isShowError = true
            return false
        }
        
        let config = APIConfig(apiKey: apiKey, model: model, stream: stream, temperature: temperature, basePrompt: basePrompt)
        if self.api == nil {
            self.api = API(config: config)
        }
        self.api?.config = config
        return true
    }
}

extension ViewModel {
    
    private func fetchMessageData() {
        if !isSaveHistory {
            return
        }
        guard let data = MessageDataService().getData() else {
            return
        }
        
        do {
            let jsonDecoder = JSONDecoder()
            let messages = try jsonDecoder.decode([Message].self, from: data)
            logger.info("persisted message data: \(messages.count) records.")
            self.messages.append(contentsOf: messages)
        } catch {
            logger.error("fetch message data occur error: \(error.localizedDescription)")
        }
    }
    
    private func saveMessageData() {
        if !isSaveHistory {
            return
        }
        
        Task {
            logger.info("save messages \(self.messages.count) records at thread: \(Thread.current)")
            do {
                let data = try JSONEncoder().encode(messages)
                MessageDataService().saveData(data: data)
            } catch {
                logger.error("save message data occur error: \(error.localizedDescription)")
            }
        }
    }
    
    public func clearMessageData() {
        if !isSaveHistory {
            return
        }
        
        Task { @MainActor in
            self.messages.removeAll()
        }
        
        Task {
            MessageDataService().clear()
        }
    }
}

// MARK: - Profile
extension ViewModel {
    func saveImageData(imageData: Data?) {
        profileService.saveData(data: imageData)
    }
}

// MARK: - Speaking
extension ViewModel {
    
   private func speakLastResponse() {
        guard let synthesizer = synthesizer, let responseText = self.messages.last?.responseText, !responseText.isEmpty else {
            return
        }
        stopSpeaking()
        
        let utterance = AVSpeechUtterance(string: responseText)
        utterance.voice = .init(language: language)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        synthesizer.speak(utterance )
    }
    
    private func stopSpeaking() {
        synthesizer?.stopSpeaking(at: .immediate)
    }
}

extension ViewModel {
    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        return df
    }()
}
