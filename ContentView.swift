//
//  ContentView.swift
//  LaunchpadReplacement
//
//  Created by 2979820979 on 8/28/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appManager = AppManager()
    @State private var showingSettings = false
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            VisualEffectView(material: .underWindowBackground,
                           blendingMode: .behindWindow,
                           transparency: 0.6)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    TextField("搜索", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(8)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.leading, 20)
                    
                    Spacer()
                    
                    Button(action: { showingSettings.toggle() }) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 18))
                            .padding(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, 20)
                }
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.2))
                
                LaunchpadView(searchText: searchText)
                    .environmentObject(appManager)
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .environmentObject(appManager)
        }
    }
}
