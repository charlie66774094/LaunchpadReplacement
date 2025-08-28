//
//  LaunchpadView.swift
//  LaunchpadReplacement
//
//  Created by 2979820979 on 8/28/25.
//

import SwiftUI

struct LaunchpadView: View {
    @EnvironmentObject var appManager: AppManager
    let searchText: String
    @State private var showingFolder: Folder? = nil
    @State private var dragging: AppItem?
    @State private var dropTarget: AppItem?
    @State private var showFolderCreation = false
    @State private var folderName = "新建文件夹"
    @State private var appsToFolder: [AppItem] = []
    
    var filteredApps: [AppItem] {
        if searchText.isEmpty {
            return appManager.apps
        } else {
            return appManager.apps.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: columnCount(for: geometry.size.width)), spacing: 30) {
                        ForEach(filteredApps) { app in
                            if let folder = app as? Folder {
                                FolderView(folder: folder, showingFolder: $showingFolder)
                                    .onDrop(of: ["public.text"], isTargeted: nil) { providers in
                                        handleDrop(to: folder, providers: providers)
                                    }
                            } else {
                                AppIconView(app: app)
                                    .opacity(dragging?.id == app.id ? 0.5 : 1.0)
                                    .onDrag {
                                        dragging = app
                                        return NSItemProvider(object: app.id.uuidString as NSString)
                                    }
                                    .onDrop(of: ["public.text"], isTargeted: nil) { providers in
                                        handleDrop(to: app, providers: providers)
                                    }
                            }
                        }
                    }
                    .padding(30)
                }
                
                if showFolderCreation {
                    FolderCreationDialog(
                        folderName: $folderName,
                        isShowing: $showFolderCreation,
                        onCreate: {
                            appManager.createFolder(with: appsToFolder, named: folderName)
                            folderName = "新建文件夹"
                            appsToFolder = []
                        },
                        onCancel: {
                            folderName = "新建文件夹"
                            appsToFolder = []
                        }
                    )
                }
            }
        }
        .sheet(item: $showingFolder) { folder in
            FolderDetailView(folder: folder)
        }
    }
    
    private func handleDrop(to target: AppItem, providers: [NSItemProvider]) -> Bool {
        guard let dragging = dragging, dragging.id != target.id else { return false }
        
        if let folder = target as? Folder {
            if !folder.containsApp(dragging) {
                appManager.apps.removeAll { $0.id == dragging.id }
                folder.addApp(dragging)
                return true
            }
        } else {
            appsToFolder = [dragging, target]
            showFolderCreation = true
            return true
        }
        
        return false
    }
    
    private func columnCount(for width: CGFloat) -> Int {
        let idealIconWidth: CGFloat = 80
        let spacing: CGFloat = 20
        return max(4, Int(width / (idealIconWidth + spacing)))
    }
}

struct FolderCreationDialog: View {
    @Binding var folderName: String
    @Binding var isShowing: Bool
    let onCreate: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("新建文件夹")
                .font(.headline)
            
            TextField("文件夹名称", text: $folderName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 200)
            
            HStack(spacing: 20) {
                Button("取消") {
                    onCancel()
                    isShowing = false
                }
                
                Button("创建") {
                    onCreate()
                    isShowing = false
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3))
    }
}
