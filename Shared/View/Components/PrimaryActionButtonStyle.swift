//
//  PrimaryActionButtonStyle.swift
//  ChatGPT
//
//  Created by peak on 2023/2/22.
//

import SwiftUI

struct PrimaryActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
#if os(iOS)
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
#else
            .padding(.vertical, 5)
#endif
            .background(.indigo.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 1.03 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PrimaryActionButtonStyle {
    /// A button style that represent a normal primary action behavior
    static var primaryAction: PrimaryActionButtonStyle { .init() }
}
