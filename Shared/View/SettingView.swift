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
    @State private var isShowClearProfileImageAlert: Bool = false
    #endif
    
    @State private var isShowClearChatHistoryAlert: Bool = false
    
    var body: some View {
        Form {
            APISettings()
            
            #if os(iOS)
            Profile()
            #endif
            
            OptionalSettings()
        }
        .alert(isPresented: $isShowClearChatHistoryAlert) {
            Alert(title: Text("Clear All Chat History?"), primaryButton: .destructive(Text("Confirm"), action: {
                vm.clearMessageData()
                #if os(iOS)
                dismiss()
                #endif
            }), secondaryButton: .cancel())
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
                Button(role: .destructive) {
                    isShowClearChatHistoryAlert.toggle()
                } label: {
                    Text("Clear Chat History")
                        .frame(maxWidth: .infinity)
                }
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
                Text("Select from Photo Library")
                    .foregroundColor(.indigo)
            }
        } header: {
            Text("Profile").textCase(.none)
        } footer: {
            if let selectImageData = vm.imageData {
                HStack {
                    Text("Local Profile")
                    Spacer()
                    ProfileView(data: selectImageData)
                        .onTapGesture {
                            isShowClearProfileImageAlert.toggle()
                        }
                }
                .alert(isPresented: $isShowClearProfileImageAlert) {
                    Alert(title: Text("Do you want remove profile image?"), primaryButton: .destructive(Text("Confirm"), action: {
                        vm.removeImageData()
                    }), secondaryButton: .cancel())
                }
            } else {
                Text("No set profile")
            }
        }
    }
    #endif
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
