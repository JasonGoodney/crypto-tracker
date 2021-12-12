//
//  EmptyStateView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/13/21.
//

import SwiftUI

enum EmptyState {
    case none
    case napping
    
    var text: String {
        switch self {
        case .none:
            return ""
        case .napping:
            return "The coins must be napping ☺️"
        }
    }
}

struct EmptyStateView: View {
    let emptyState: EmptyState = .none
    
    let textOffsetY: CGFloat = -200
    
    let iconOffsetX: CGFloat = UIScreen.main.bounds.maxX * 0.25
    
    let iconOffsetY: CGFloat = UIScreen.main.bounds.maxY * 0.2
    
    let iconSize: CGFloat = 400
    
    let foregroundColor: Color = .gullGray
    
    var body: some View {
        ZStack {
            Text(emptyState.text)
                .font(.largeTitle)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .foregroundColor(foregroundColor)
                .offset(x: 0,
                        y: textOffsetY)
                .padding(.horizontal)
                
            Image(Icon.logo.rawValue)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(foregroundColor)
                .frame(width: iconSize,
                       height: iconSize)
                .offset(x: iconOffsetX,
                        y: iconOffsetY)
        }
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            NavigationView {
                EmptyStateView()
                    .navigationTitle("Hello, World!")
            }
        }
        
//        ForEach(AllDeviceNames.iPhone12.map { $0.rawValue }, id: \.self) { devicesName in
//            TabView {
//                NavigationView {
//                    EmptyStateView()
//                        .navigationTitle("Hello, World!")
//                }
//            }
//            .previewDevice(PreviewDevice(rawValue: devicesName))
//            .previewDisplayName(devicesName)
//        }
    }
}
