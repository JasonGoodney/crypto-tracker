//
//  Text+Ext.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/4/21.
//

import SwiftUI

extension Text {
    func sectionTitleStyle() -> some View {
        self
            .font(.headline)
            .fontWeight(.black)
            .padding(.bottom, 8)
    }
    
    func sectionHeadline2Style() -> some View {
        self
            .font(.headline)
            .padding(.bottom, 4)
    }
}
