//
//  SettingsView.swift
//  LaunchpadReplacement
//
//  Created by 2979820979 on 8/28/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appManager: AppManager
    @Environment(\.dismiss) var dismiss
    @State private var autoRefresh = true
    @State private var showHiddenApps = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("设置")
                .font(.title2)
                .fontWeight(.bold)
            
            Toggle("自动刷新应用列表", isOn: $autoRefresh)
            
            Toggle("显示隐藏的应用", isOn: $showHiddenApps)
            
            if showHiddenApps {
                List {
                    ForEach(appManager.hiddenApps) { app in
                        HStack {
                            if let icon = app.icon {
                                Image(nsImage: icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                            }
                            
                            Text(app.name)
                            
                            Spacer()
                            
                            Button("取消隐藏") {
                                appManager.unhideApp(app)
                            }
                        }
                    }
                }
                .frame(height: 200)
            }
            
            Button("手动刷新应用列表") {
                appManager.refreshAppList()
            }
            
            Divider()
            
            Button("重置布局") {
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button("完成") {
                    dismiss()
                }
            }
        }
        .padding()
        .frame(width: 300, height: 400)
    }
}
