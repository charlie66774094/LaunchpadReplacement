//
//  Folder.swift
//  LaunchpadReplacement
//
//  Created by 2979820979 on 8/28/25.
//

import SwiftUI
import AppKit
import Combine

class Folder: AppItem {
    @Published var apps: [AppItem] = []
    
    init(name: String, apps: [AppItem]) {
        self.apps = apps
        super.init(name: name, path: "", bundleIdentifier: nil, position: 0)
    }
    
    func addApp(_ app: AppItem) {
        apps.append(app)
        objectWillChange.send()
    }
    
    func removeApp(_ app: AppItem) {
        apps.removeAll { $0.id == app.id }
        objectWillChange.send()
    }
    
    func containsApp(_ app: AppItem) -> Bool {
        apps.contains { $0.id == app.id }
    }
    
    var appCount: Int {
        apps.count
    }
    
    override func loadIcon() {
        if apps.count >= 4 {
            self.icon = createFolderIcon()
        } else {
            let workspace = NSWorkspace.shared
            self.icon = workspace.icon(forFile: "/System")
        }
    }
    
    private func createFolderIcon() -> NSImage {
        let imageSize = NSSize(width: 60, height: 60)
        let image = NSImage(size: imageSize)
        
        image.lockFocus()
        
        NSColor.gray.withAlphaComponent(0.3).set()
        NSBezierPath(roundedRect: NSRect(origin: .zero, size: imageSize), xRadius: 12, yRadius: 12).fill()
        
        if apps.count > 0, let icon1 = apps[0].icon {
            drawMiniIcon(icon1, at: NSPoint(x: 8, y: 30), size: NSSize(width: 20, height: 20))
        }
        if apps.count > 1, let icon2 = apps[1].icon {
            drawMiniIcon(icon2, at: NSPoint(x: 30, y: 30), size: NSSize(width: 20, height: 20))
        }
        if apps.count > 2, let icon3 = apps[2].icon {
            drawMiniIcon(icon3, at: NSPoint(x: 8, y: 8), size: NSSize(width: 20, height: 20))
        }
        if apps.count > 3, let icon4 = apps[3].icon {
            drawMiniIcon(icon4, at: NSPoint(x: 30, y: 8), size: NSSize(width: 20, height: 20))
        }
        
        image.unlockFocus()
        return image
    }
    
    private func drawMiniIcon(_ icon: NSImage, at point: NSPoint, size: NSSize) {
        let rect = NSRect(origin: point, size: size)
        icon.draw(in: rect, from: NSRect(origin: .zero, size: icon.size), operation: .sourceOver, fraction: 1.0)
    }
}

