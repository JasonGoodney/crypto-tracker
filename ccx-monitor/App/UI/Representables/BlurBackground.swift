//
//  BlurBackground.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/28/21.
//

import SwiftUI

struct BlurBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

