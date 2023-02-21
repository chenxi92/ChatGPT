//
//  ThreeDotLoadingView.swift
//  ChatGPT
//
//  Created by 陈希 on 2023/2/19.
//

import SwiftUI

struct ThreeDotLoadingView: View {
    @State private var dotCount = 0
    
    @State var timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(index == dotCount ? .black : .secondary.opacity(0.5))
            }
        }
        .onReceive(timer) { _ in
            dotCount = (dotCount + 1) % 3
        }
    }
}

struct ThreeDotLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ThreeDotLoadingView()
        }
    }
}
