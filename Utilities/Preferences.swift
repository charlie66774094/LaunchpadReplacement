//
//  Preferences.swift
//  LaunchpadReplacement
//
//  Created by 2979820979 on 8/28/25.
//

import Foundation

class Preferences {
    static let shared = Preferences()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let hiddenApps = "hiddenApps"
        static let folders = "folders"
        static let appPositions = "appPositions"
    }
    
    func saveHiddenApps(_ apps: [AppItem]) {
        let appData = apps.map { ["name": $0.name, "path": $0.path, "bundleIdentifier": $0.bundleIdentifier ?? ""] }
        defaults.set(appData, forKey: Keys.hiddenApps)
    }
    
    func loadHiddenApps() -> [[String: String]] {
        defaults.array(forKey: Keys.hiddenApps) as? [[String: String]] ?? []
    }
    
    func saveAppPositions(_ positions: [String: Int]) {
        defaults.set(positions, forKey: Keys.appPositions)
    }
    
    func loadAppPositions() -> [String: Int] {
        defaults.dictionary(forKey: Keys.appPositions) as? [String: Int] ?? [:]
    }
    
    func saveFolders(_ folders: [Folder]) {
        let folderData = folders.map { folder -> [String: Any] in
            [
                "name": folder.name,
                "appPaths": folder.apps.map { $0.path }
            ]
        }
        defaults.set(folderData, forKey: Keys.folders)
    }
    
    func loadFolders() -> [[String: Any]] {
        defaults.array(forKey: Keys.folders) as? [[String: Any]] ?? []
    }
    
    private init() {
        defaults.register(defaults: [
            Keys.hiddenApps: [],
            Keys.folders: [],
            Keys.appPositions: [:]
        ])
    }
}
