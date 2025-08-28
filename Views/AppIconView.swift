//
//  AppIconView.swift
//  LaunchpadReplacement
//
//  Created by 2979820979 on 8/28/25.
//

import SwiftUI

struct AppIconView: View {
    @EnvironmentObject var appManager: AppManager
    let app: AppItem
    @State private var isHovering = false
    @State private var showContextMenu = false
    
    var body: some View {
        VStack(spacing: 5) {
            if let nsImage = app.icon {
                Image(nsImage: nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                    .scaleEffect(isHovering ? 1.1 : 1.0)
            } else {
                Image(systemName: "questionmark.square")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
            }
            
            Text(app.name)
                .font(.system(size: 12))
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(width: 80)
        }
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hovering
            }
        }
        .onTapGesture {
            app.launch()
        }
        .contextMenu {
            Button("显示在Finder中") {
                app.showInFinder()
            }
            
            Button("从启动台移除") {
                appManager.hideApp(app)
            }
            
            if app.isHidden {
                Button("取消隐藏") {
                    appManager.unhideApp(app)
                }
            }
        }
    }
}
