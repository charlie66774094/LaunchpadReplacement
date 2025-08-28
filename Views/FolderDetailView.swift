//
//  FolderDetailView.swift
//  LaunchpadReplacement
//
//  Created by 2979820979 on 8/28/25.
//

import SwiftUI

struct FolderDetailView: View {
    let folder: Folder
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VisualEffectView(material: .fullScreenUI, blendingMode: .behindWindow)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text(folder.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button("完成") {
                        dismiss()
                    }
                }
                .padding()
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 6), spacing: 30) {
                        ForEach(folder.apps) { app in
                            AppIconView(app: app)
                        }
                    }
                    .padding()
                }
            }
        }
        .frame(width: 600, height: 500)
    }
}
