//
//  AppItem.swift
//  LaunchpadReplacement
//
//  Created by 2979820979 on 8/28/25.
//

import AppKit
import Combine

class AppItem: Identifiable, ObservableObject {
    let id = UUID()
    let name: String
    let path: String
    let bundleIdentifier: String?
    
    @Published var icon: NSImage?
    @Published var isHidden: Bool = false
    @Published var position: Int = 0
    
    init(name: String, path: String, bundleIdentifier: String?, position: Int = 0) {
        self.name = name
        self.path = path
        self.bundleIdentifier = bundleIdentifier
        self.position = position
        loadIcon()
    }
    
    func loadIcon() {
        let workspace = NSWorkspace.shared
        icon = workspace.icon(forFile: path)
    }
    
    func launch() {
        let url = URL(fileURLWithPath: path)
        NSWorkspace.shared.open(url)
    }
    
    func showInFinder() {
        let url = URL(fileURLWithPath: path)
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
    
    func toggleHidden() {
        isHidden.toggle()
    }
}

extension AppItem: Equatable {
    static func == (lhs: AppItem, rhs: AppItem) -> Bool {
        lhs.id == rhs.id
    }
}

extension AppItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
