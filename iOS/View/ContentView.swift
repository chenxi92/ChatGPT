//
//  ContentView.swift
//  Shared
//
//  Created by peak on 2023/2/17.
//

import SwiftUI

struct ContentView: View {
        
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationView {
            MainView()
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("ChatGPT")
                .toolbar {
                    trailNavitationBar
                }
//                .alert(vm.errorMessage, isPresented: $vm.isShowError) {
//                    Button("OK", role: .cancel) {
//                        vm.reset()
//                    }
//                }
        }
    }
    
    var trailNavitationBar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink {
                SettingView()
            } label: {
                Image(systemName: "gear")
                    .foregroundColor(Color(UIColor.gray))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}
