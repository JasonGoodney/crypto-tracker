//
//  PercentChangeLabel.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/27/21.
//

import SwiftUI

struct PercentChangeLabel: View {
    
    private let value: Double
    
    private var font: Font?
    
    private var isPositive: Bool {
        value > 0
    }
    
    private var isNeutral: Bool {
        value == 0
    }
    
    private let neutralArrow = "arrowtriangle.right.fill"
    
    private let positiveArrow = "arrowtriangle.up.fill"
    
    private let negativeArrow = "arrowtriangle.down.fill"
    
    private var arrowName: String {
        if isNeutral {
          return neutralArrow
        } else {
            return isPositive ? positiveArrow : negativeArrow
        }
    }
    
    private var foregroundColor: Color {
        if isNeutral {
            return .regentGray
        } else {
            return isPositive ? .caribbeanGreen : .razzmattazz
        }
    }
    
    init(value: Double, font: Font? = .headline) {
        self.value = value
        self.font = font
    }
    
    var body: some View {
        HStack {
            Image(systemName: arrowName)
                .font(.footnote)
            
            Text(String(value)
                    .replacingOccurrences(of: "-", with: "")) + Text("%")
        }
        .font(font)
        .foregroundColor(foregroundColor)
    }
}

struct PercentChangeLabel_Previews: PreviewProvider {
    static var previews: some View {
        PercentChangeLabel(value: -2.40)
    }
}
