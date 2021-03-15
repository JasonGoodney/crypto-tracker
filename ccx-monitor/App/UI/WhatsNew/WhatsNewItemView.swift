//
//  WhatsNewItemView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/8/21.
//

import SwiftUI

struct WhatsNewItemView: View {
    let imageName: String
    let imageColor: Color
    let headline: String
    let subHeadline: String
    
    var body: some View {
        HStack(spacing: 30) {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(imageColor)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(headline)
                    .font(.headline)
                Text(subHeadline)
            }
        }
    }
}

struct WhatsNewItemView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewItemView(imageName: "newspaper.fill",
                         imageColor: Color.caribbeanGreen,
                         headline: "Latest News",
                         subHeadline: "Stay up to date on the cryptocurrency news")
    }
}
