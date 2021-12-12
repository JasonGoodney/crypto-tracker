//
//  LikeButton.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/14/21.
//

import SwiftUI

struct LikeButton: View {
    @State var isPressed = false
    var action: (Bool) -> Void

    @State var scale: CGFloat = 1
    @State var opacity = 0.0

    init(isPressed: Bool, action: @escaping (Bool) -> Void) {
        self.action = action
        _isPressed = State(initialValue: isPressed)
    }

    var body: some View {
        ZStack {
            Image(systemName: "heart.circle.fill")
                .opacity(isPressed ? 1 : 0)
                .scaleEffect(isPressed ? 1.0 : 0.1)
            Image(systemName: "heart.circle.fill")
        }
//        .font(.system(size: 32))
        .onTapGesture {
            action(isPressed)
            withAnimation {
                isPressed.toggle()
            }
        }
        .foregroundColor(isPressed
                            ? Color(UIColor.systemRed)
                            : Color(UIColor.label).opacity(0.5))
        .onTapGesture {
            withAnimation {
                isPressed.toggle()
            }
            
            withAnimation(.linear(duration: 0.2)) {
                scale = scale == 1 ? 1.3 : 1
                opacity = opacity == 0 ? 1 : 0
            }
            withAnimation {
                opacity = opacity == 0 ? 1 : 0
            }
        }
        .scaleEffect(scale)
    }
}

struct LikeButton_Previews: PreviewProvider {
    static var previews: some View {
        LikeButton(isPressed: true, action: { _ in
            print("Tapped")
        })
    }
}
