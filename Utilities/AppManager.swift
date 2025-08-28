//
//  AppManager.swift
//  LaunchpadReplacement
//
//  Created by 2979820979 on 8/28/25.
//

import AppKit
import Combine

class AppManager: ObservableObject {
    @Published var apps: [AppItem] = []
    @Published var folders: [Folder] = []
    @Published var hiddenApps: [AppItem] = []
    
    init() {
        loadAllData()
    }
    
    func refreshAppList() {
        apps.removeAll()
        folders.removeAll()
        hiddenApps.removeAll()
        
        loadSystemApps()
        
        restoreSavedData()
    }
    
    private func loadSystemApps() {
        let systemAppDirs = [
            "/Applications",
            "/System/Applications",
            "/System/Library/CoreServices"
        ]
        
        let userAppDir = "\(NSHomeDirectory())/Applications"
        let allAppDirs = systemAppDirs + [userAppDir]
        
        for dir in allAppDirs {
            loadApps(from: dir)
        }
    }
    
    private func loadApps(from directory: String) {
        let fileManager = FileManager.default
        
        guard let contents = try? fileManager.contentsOfDirectory(atPath: directory) else {
            return
        }
        
        for (index, item) in contents.enumerated() {
            let fullPath = "\(directory)/\(item)"
            
            if item.hasSuffix(".app") {
                let appName = item.replacingOccurrences(of: ".app", with: "")
                let bundle = Bundle(path: fullPath)
                let bundleIdentifier = bundle?.bundleIdentifier
                
                let appItem = AppItem(name: appName, path: fullPath, bundleIdentifier: bundleIdentifier, position: index)
                apps.append(appItem)
            }
        }
    }
    
    private func restoreSavedData() {
        let positions = Preferences.shared.loadAppPositions()
        if !positions.isEmpty {
            apps.sort { (app1, app2) -> Bool in
                let pos1 = positions[app1.path] ?? app1.position
                let pos2 = positions[app2.path] ?? app2.position
                return pos1 < pos2
            }
            
            for (index, app) in apps.enumerated() {
                app.position = index
            }
        }
        
        let folderData = Preferences.shared.loadFolders()
        for data in folderData {
            guard let name = data["name"] as? String,
                  let appPaths = data["appPaths"] as? [String] else {
                continue
            }
            
            var folderApps: [AppItem] = []
            for path in appPaths {
                if let app = apps.first(where: { $0.path == path }) {
                    folderApps.append(app)
                    apps.removeAll { $0.path == path }
                }
            }
            
            if !folderApps.isEmpty {
                let folder = Folder(name: name, apps: folderApps)
                folders.append(folder)
                apps.append(folder)
            }
        }
        
        let hiddenAppData = Preferences.shared.loadHiddenApps()
        for data in hiddenAppData {
            if let path = data["path"] {
                if let app = apps.first(where: { $0.path == path }) {
                    hideApp(app, save: false) // 不立即保存，避免循环
                }
            }
        }
    }
    
    func moveItem(from source: Int, to destination: Int) {
        guard source != destination else { return }
        
        let item = apps.remove(at: source)
        apps.insert(item, at: destination)
        
        updateAndSavePositions()
    }
    
    private func updateAndSavePositions() {
        var positions: [String: Int] = [:]
        for (index, app) in apps.enumerated() {
            app.position = index
            positions[app.path] = index
        }
        Preferences.shared.saveAppPositions(positions)
    }
    
    func createFolder(with apps: [AppItem], named name: String) {
        self.apps.removeAll { app in
            apps.contains { $0.id == app.id }
        }
        
        let newFolder = Folder(name: name, apps: apps)
        self.apps.append(newFolder)
        folders.append(newFolder)
        
        Preferences.shared.saveFolders(folders)
        updateAndSavePositions()
    }
    
    func hideApp(_ app: AppItem, save: Bool = true) {
        if let index = apps.firstIndex(where: { $0.id == app.id }) {
            let hiddenApp = apps.remove(at: index)
            hiddenApp.isHidden = true
            hiddenApps.append(hiddenApp)
            
            if save {
                Preferences.shared.saveHiddenApps(hiddenApps)
                updateAndSavePositions()
            }
        }
    }
    
    func unhideApp(_ app: AppItem) {
        if let index = hiddenApps.firstIndex(where: { $0.id == app.id }) {
            let unhiddenApp = hiddenApps.remove(at: index)
            unhiddenApp.isHidden = false
            apps.append(unhiddenApp)
            
            Preferences.shared.saveHiddenApps(hiddenApps)
            updateAndSavePositions()
        }
    }
    
    func saveAllData() {
        Preferences.shared.saveHiddenApps(hiddenApps)
        Preferences.shared.saveFolders(folders)
        
        var positions: [String: Int] = [:]
        for (index, app) in apps.enumerated() {
            positions[app.path] = index
        }
        Preferences.shared.saveAppPositions(positions)
    }
    
    private func loadAllData() {
        refreshAppList()
    }
}
