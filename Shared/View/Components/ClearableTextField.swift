//
//  ClearableTextField.swift
//  ChatGPT
//
//  Created by peak on 2023/2/17.
//

import SwiftUI

struct ClearableTextField: View {
    var title: String = ""
    
    @Binding var text: String
    
    var body: some View {
        TextField(title, text: $text)
        #if os(iOS)
            .autocapitalization(.none)
        #endif
            .modifier(ClearButton(text:$text))
    }
}

struct ClearButton: ViewModifier {
    @Binding var text: String
    func body(content: Content) -> some View {
        HStack {
            content
            if !text.isEmpty {
                Button {
                    DispatchQueue.main.async {
                        self.text = ""
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct TextField_Previews: PreviewProvider {
    static var previews: some View {
        ClearableTextField(title: "This is a custom text", text: .constant("text"))
    }
}
