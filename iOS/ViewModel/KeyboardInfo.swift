//
//  KeyboardInfo.swift
//  ChatGPT (iOS)
//
//  Created by peak on 2023/2/24.
//

import SwiftUI

public class KeyboardInfo: ObservableObject {

    public static var shared = KeyboardInfo()

    @Published public var height: CGFloat = 0

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func keyboardChanged(notification: Notification) {
        var keyboardHeight: CGFloat
        if notification.name == UIApplication.keyboardWillHideNotification {
            keyboardHeight = 0
        } else {
            keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.height = keyboardHeight
        }
    }

}
