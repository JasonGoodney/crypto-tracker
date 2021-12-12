//
//  ButtonStyles.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/8/21.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.title3.weight(.bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, idealHeight: 50, maxHeight: 50)
            .background(Color.blue)
            .cornerRadius(10)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.body.weight(.bold))
            .foregroundColor(.woodsmoke)
            .frame(width: 200, height: 50)
            .background(Color(.mystic))
            .cornerRadius(25)
    }
}

struct NavigationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 32, height: 32)
            .foregroundColor(Color(UIColor.label).opacity(0.5))
    }
}

struct LikeButtonStyle: ButtonStyle {
//    @State var isPressed = false
    @State var scale: CGFloat = 1
    @State var opacity = 0.0

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                ZStack {
                    Image(systemName: "heart.circle.fill")
                        .opacity(configuration.isPressed ? 1 : 0)
                        .scaleEffect(configuration.isPressed ? 1.0 : 0.1)
                        .animation(.linear)
                    Image(systemName: "heart.circle.fill")
                }
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .foregroundColor(configuration.isPressed ? .red : Color.black.opacity(0.3))
    }
}

struct ButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: /*@START_MENU_TOKEN@*/ {}/*@END_MENU_TOKEN@*/, label: {
            Image(systemName: "heart.circle.fill")
        })
            .buttonStyle(LikeButtonStyle())
    }
}
