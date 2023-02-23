//
//  SettingView.swift
//  ChatGPT
//
//  Created by peak on 2023/2/17.
//

import SwiftUI
#if os(macOS)
import AppKit
#endif

struct SettingView: View {
    
    @EnvironmentObject var vm: ViewModel
    
    #if os(iOS)
    @Environment(\.dismiss) var dismiss
    @State private var isPresentImagePicker: Bool = false
    #endif
    
    @State private var isShowClearProfileImageAlert: Bool = false
    @State private var isShowClearChatHistoryAlert: Bool = false
    
    var body: some View {
        Form {
            APISettings()
            Profile()
                .destructiveAlert(isPresented: $isShowClearProfileImageAlert, title: "Do you want remove profile image?") {
                    vm.removeImageData()
                }
            OptionalSettings()
                .destructiveAlert(isPresented: $isShowClearChatHistoryAlert, title: "Clear All Chat History?") {
                    vm.clearMessageData()
                    #if os(iOS)
                    dismiss()
                    #endif
                }
        }
        #if os(macOS)
        .padding()
        .padding(.trailing)
        #endif
        
        #if os(iOS)
        .sheet(isPresented: $isPresentImagePicker) {
            ImagePicker(selectImageData: $vm.imageData, isPresented: $isPresentImagePicker)
        }
        .onChange(of: vm.imageData) {newValue in
            vm.saveImageData(imageData: newValue)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
    
    func APISettings() -> some View {
        Section {
            TextField("API Key", text: $vm.apiKey)
                .textFieldStyle(.automatic)
            
            Picker("GPT Model", selection: $vm.model) {
                ForEach(Model.GPT3.allCases) { model in
                    Text(model.rawValue)
                        .tag(model.rawValue)
                }
            }
            .pickerStyle(.automatic)
            
            Toggle("Stream", isOn: $vm.stream)
                .toggleStyle(.switch)
            
            VStack(alignment: .leading) {
                Slider(value: $vm.temperature, in: 0...1, step: 0.1) {
                    Text("Temperature")
                } minimumValueLabel: {
                    Text("0")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                } maximumValueLabel: {
                    Text("1")
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                
                HStack {
                    Text("Temperature: ")
                    Text(String(format: "%.1f", vm.temperature))
                        .font(.body.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            #if os(iOS)
            VStack(alignment: .leading, spacing: 3) {
                Text("Base Prompt")
                    .fontWeight(.semibold)
                
                TextEditor(text: $vm.basePrompt)
                    .frame(maxWidth: .infinity, idealHeight: 200, alignment: .leading)
                    .foregroundColor(.secondary)
                    .lineSpacing(5)
            }
            #endif
            
            #if os(macOS)
            TextEditor(text: $vm.basePrompt)
                .frame(maxWidth: .infinity, maxHeight: 120)
                .foregroundColor(.secondary)
                .lineSpacing(5)
                .font(.body)
            #endif
        } header: {
            #if os(iOS)
            Text("ChatGPT API")
            #endif
        }
    }
    
    func OptionalSettings() -> some View {
        Section {
            
            Toggle("Save Chat History", isOn: $vm.isSaveHistory)
                .toggleStyle(.switch)
            
            if vm.isSaveHistory {
                Button {
                    withAnimation(.spring()) {
                        isShowClearChatHistoryAlert.toggle()
                    }
                } label: {
                    Text("Clear Chat History")
                }
                .buttonStyle(.destructive)
            }
            
            Toggle("Enable Synthesizer", isOn: $vm.isEnableSynthesizer)
                .toggleStyle(.switch)
            
            if vm.isEnableSynthesizer {
                Picker("Language", selection: $vm.language) {
                    ForEach(Language.allCases) { language in
                        Text(language.name)
                            .tag(language.tag)
                    }
                }
                #if os(macOS)
                .pickerStyle(.inline)
                #else
                .pickerStyle(.automatic)
                #endif
            }
        } header: {
            #if os(iOS)
            Text("Optional")
            #endif
        }
        
    }
    
    #if os(iOS)
    func Profile() -> some View {
        Section {
            Button {
                isPresentImagePicker.toggle()
            } label: {
                Text("Select Profile from your Phone")
            }
            .buttonStyle(.primaryAction)
        } header: {
            Text("Profile").textCase(.none)
        } footer: {
            ProfileSectionFooter()
        }
    }
    #else
    func Profile() -> some View {
        Section {
            Button {
                openPannel()
            } label: {
                Text("Select Profile from your computer")
            }
            .buttonStyle(.primaryAction)
        } header: {
//            Text("Profile")
//                .textCase(.none)
//                .font(.title3)
        } footer: {
            ProfileSectionFooter()
        }
    }
    
    func openPannel() {
        let pannel = NSOpenPanel()
        pannel.allowsMultipleSelection = false
        pannel.canChooseDirectories = false
        pannel.allowedContentTypes = [.png, .jpeg]
        if pannel.runModal() == .OK, let url = pannel.url {
            vm.saveImageData(from: url)
        }
    }
    #endif
    
    @ViewBuilder
    func ProfileSectionFooter() -> some View {
        if let selectImageData = vm.imageData {
            HStack(alignment: .bottom) {
                Text("Profile")
                Spacer()
                ProfileView(data: selectImageData)
                    .onTapGesture {
                        isShowClearProfileImageAlert.toggle()
                    }
                Text("click to delete")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        } else {
            Text("No set profile")
        }
    }
}


struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        #if os(iOS)
        NavigationView {
            SettingView()
                .environmentObject(ViewModel())
        }
        #else
        SettingView()
            .environmentObject(ViewModel())
        #endif
    }
}
