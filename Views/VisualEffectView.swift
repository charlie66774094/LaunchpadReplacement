//
//  VisualEffectView.swift
//  LaunchpadReplacement
//
//  Created by 2979820979 on 8/28/25.
//

import SwiftUI

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    let transparency: Double
    
    init(material: NSVisualEffectView.Material = .fullScreenUI,
         blendingMode: NSVisualEffectView.BlendingMode = .behindWindow,
         transparency: Double = 1.0) {
        self.material = material
        self.blendingMode = blendingMode
        self.transparency = transparency
    }
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = .active
        
        visualEffectView.alphaValue = transparency
        
        return visualEffectView
    }
    
    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.alphaValue = transparency 
    }
}
