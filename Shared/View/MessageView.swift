//
//  MessageView.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 02/02/23.
//

import SwiftUI
import MarkdownUI


struct MessageView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let message: Message
    let retryCallback: (Message) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            RequestRow()
            Divider()
            ResponseView()
            Divider()
        }
        .textSelection(.enabled)
    }
    
    func RequestRow() -> some View {
        HStack(alignment: .top, spacing: 20) {
            if let imageData = message.sendImageData {
                ProfileView(data: imageData)
            } else {
                ProfileView(name: message.sendImage)                
            }
            
            VStack(alignment: .leading) {
                Text(message.sendText)
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                    .textSelection(.enabled)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(whiteBackgroundColor)
    }
    
    func ResponseView() -> some View {
        HStack(alignment: .top, spacing: 20) {
            
            ProfileView(name: message.responseImage)
            
            VStack(alignment: .leading) {
                
                if !message.responseText.isEmpty {
                    Markdown(message.responseText)
                        .textSelection(.enabled)
                        .markdownTheme(.gitHub)
                }
                
                if message.isInteractingWithChatGPT {
                    ThreeDotLoadingView()
                }
                
                if let responseError = message.responseError {
                    ErrorView(responseError)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(grayBackgroundColor)
    }
    
    @ViewBuilder
    func ErrorView(_ errorMessage: String) -> some View {
        Text("Error: \(errorMessage)")
            .foregroundColor(.red)
            .multilineTextAlignment(.leading)
        
        Button("Regenerate response") {
            retryCallback(message)
        }
        .foregroundColor(.accentColor)
        .padding(.top)
    }
}

extension MessageView {
    
    private var whiteBackgroundColor: Color {
        if colorScheme == .light {
            return .white
        }
        return Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5)
    }
    
    private var grayBackgroundColor: Color {
        if colorScheme == .light {
            return .gray.opacity(0.1)
        }
        return Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 1)
    }
}

struct MessageRowView_Previews: PreviewProvider {
        
    static var previews: some View {
        NavigationView {
            ScrollView {
                MessageView(message: .testNormal, retryCallback: { messageRow in
                    
                })
                
                MessageView(message: .testNormal2, retryCallback: { messageRow in
                    
                })
                    
                MessageView(message: .testError, retryCallback: { messageRow in
                    
                })
            }
            .frame(width: 400)
            .previewLayout(.sizeThatFits)
        }
    }
}
