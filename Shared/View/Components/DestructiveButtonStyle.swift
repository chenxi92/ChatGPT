//
//  TestButton.swift
//  ChatGPT
//
//  Created by peak on 2023/2/22.
//

import SwiftUI

struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
        #if os(iOS)
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
        #else
            .padding(.vertical, 5)
        #endif
            .font(.body.bold())
            .background(.red)
            .foregroundColor(configuration.isPressed ? .white : .black)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 1.05 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == DestructiveButtonStyle {
    /// A button style that represent a destructive behavior
    static var destructive: DestructiveButtonStyle { .init() }
}

struct TestDestructiveButtonStyle: View {
    var body: some View {
        VStack {
            Button {
                
            } label: {
                Text("Test")
            }
            .buttonStyle(.destructive)
            
            Button {
                
            } label: {
                Text("Test")
            }
            .buttonStyle(.primaryAction)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}


struct TestDestructiveButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        TestDestructiveButtonStyle()
    }
}
