//
//  LikeButton.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/14/21.
//

import SwiftUI

struct LikeButton: View {
        
    var action: (Bool) -> Void
    
    @State var isPressed = false
    @State var scale : CGFloat = 1
    @State var opacity  = 0.0
    
    var body: some View {
        ZStack {
            Image(systemName: "heart.circle.fill")
                .opacity(isPressed ? 1 : 0)
                .scaleEffect(isPressed ? 1.0 : 0.1)
                .animation(.linear)
            Image(systemName: "heart.circle.fill")
        }
        .font(.system(size: 32))
        .onTapGesture {
            action(isPressed)
            isPressed.toggle()
        }
        .foregroundColor(isPressed ? .red : Color.black.opacity(0.3))
        .onTapGesture {
            isPressed.toggle()
            withAnimation (.linear(duration: 0.2)) {
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
        LikeButton(action: { _ in
            print("Tapped")
        })
    }
}
