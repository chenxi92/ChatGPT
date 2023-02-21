//
//  MainView.swift
//  ChatGPT
//
//  Created by peak on 2023/2/20.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @FocusState var isTextFieldFocused: Bool
    
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ChatScrollView()
                Divider()
                BottomView(proxy: proxy)
                Spacer()
            }
            .onChange(of: vm.messages.last?.responseText) { _ in
                scrollToBottom(proxy: proxy)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 0.3)) {
                    scrollToBottom(proxy: proxy)
                }
            }
        }
        .background(backgroundColor)
        .onAppear {
            isTextFieldFocused = true
        }
        .alert(vm.errorMessage, isPresented: $vm.isShowError) {
            Button("OK", role: .cancel) {
                vm.reset()
            }
        }
    }
    
    func ChatScrollView() -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(vm.messages) { message in
                    MessageView(message: message) { message in
                        Task { @MainActor in
                            await vm.retry(message: message)
                        }
                    }
                }
            }
            .onTapGesture {
                isTextFieldFocused = false
            }
        }
    }
    
    func BottomView(proxy: ScrollViewProxy) -> some View {
        HStack(alignment: .center) {
            
            if let data = vm.imageData {
                ProfileView(data: data)
            } else {
                ProfileView(name: "person")
            }
            
            InputView(proxy: proxy)
            
            if vm.isInteractingWithChatGPT {
                ThreeDotLoadingView()
                    .frame(width: 50, height: 30)
            } else {
                SendButton(proxy: proxy)
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    func InputView(proxy: ScrollViewProxy) -> some View {
        TextField("Send message", text: $vm.inputMessage)
            .textFieldStyle(.roundedBorder)
            .focused($isTextFieldFocused)
            .disabled(vm.isInteractingWithChatGPT)
            .onSubmit {
                send(proxy: proxy)
            }
    }
    
    func SendButton(proxy: ScrollViewProxy) -> some View {
        Button {
            send(proxy: proxy)
        } label: {
            Image(systemName: "paperplane.circle.fill")
                .rotationEffect(.degrees(45))
            #if os(iOS)
                .font(.system(size: 25))
            #else
                .font(.system(size: 20))
            #endif
        }
        .buttonStyle(.borderless)
        .keyboardShortcut(.defaultAction)
        .foregroundColor(.accentColor)
        .disabled(vm.isEmptyInput)
    }
    
    private func send(proxy: ScrollViewProxy) {
        Task { @MainActor in
            isTextFieldFocused = false
            
            scrollToBottom(proxy: proxy)

            await vm.sendTapped()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isTextFieldFocused = true
            }
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else {
            return
        }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
    
    private var backgroundColor: Color {
        if colorScheme == .light {
            return .white
            
        }
        return Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MainView()
        }
        .environmentObject(ViewModel())
    }
}
