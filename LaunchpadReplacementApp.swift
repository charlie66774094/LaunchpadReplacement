//
//  LaunchpadReplacementApp.swift
//  LaunchpadReplacement
//
//  Created by 2979820979 on 8/28/25.
//

import SwiftUI

@main
struct LaunchpadReplacementApp: App {
    @StateObject private var appManager = AppManager()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appManager)
                .frame(minWidth: 800, idealWidth: 1000, maxWidth: .infinity,
                       minHeight: 600, idealHeight: 800, maxHeight: .infinity)
                .onChange(of: scenePhase) {
                    if scenePhase == .background {
                        appManager.saveAllData()
                    }
                }
        }
        .windowStyle(.hiddenTitleBar)
    }
}
