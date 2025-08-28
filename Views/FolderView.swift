//
//  FolderView.swift
//  LaunchpadReplacement
//
//  Created by 2979820979 on 8/28/25.
//

import SwiftUI

struct FolderView: View {
    let folder: Folder
    @Binding var showingFolder: Folder?
    @State private var isHovering = false
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                if folder.apps.count >= 4 {
                    VStack(spacing: 2) {
                        HStack(spacing: 2) {
                            if let icon1 = folder.apps[0].icon {
                                Image(nsImage: icon1)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 28, height: 28)
                                    .cornerRadius(5)
                            }
                            
                            if let icon2 = folder.apps[1].icon {
                                Image(nsImage: icon2)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 28, height: 28)
                                    .cornerRadius(5)
                            }
                        }
                        
                        HStack(spacing: 2) {
                            if let icon3 = folder.apps[2].icon {
                                Image(nsImage: icon3)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 28, height: 28)
                                    .cornerRadius(5)
                            }
                            
                            if let icon4 = folder.apps[3].icon {
                                Image(nsImage: icon4)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 28, height: 28)
                                    .cornerRadius(5)
                            }
                        }
                    }
                    .frame(width: 60, height: 60)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(12)
                } else {
                    Image(systemName: "folder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.yellow)
                }
            }
            .scaleEffect(isHovering ? 1.1 : 1.0)
            
            Text(folder.name)
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
            showingFolder = folder
        }
    }
}
