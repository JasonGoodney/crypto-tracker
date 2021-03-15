//
//  WhatsNewView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/7/21.
//

import SwiftUI

struct WhatsNewView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View
    {
        VStack {
            
            Spacer()
            
            Text("What's New")
                .font(.largeTitle)
                .fontWeight(.black)
                .padding(.bottom, 20)
            
        
            VStack(alignment: .leading, spacing: 30) {
                WhatsNewItemView(imageName: "newspaper.fill",
                             imageColor: Color.caribbeanGreen,
                             headline: "Latest News",
                             subHeadline: "Stay up to date on the cryptocurrency news")
                
                WhatsNewItemView(imageName: "house.fill",
                             imageColor: Color.razzmattazz,
                             headline: "Home Tab",
                             subHeadline: "Watchlist, top coins, top gainers, top losers, and news")
                
                WhatsNewItemView(imageName: "mail.stack.fill",
                             imageColor: Color.dodgerBlue,
                             headline: "Widgets",
                             subHeadline: "For a quick glance, add a widget to your home screen")
            }
            .padding(.bottom, 100)
        
            Spacer()
            
            Button(action: onContinue) {
                Text("Continue")
            }
            .buttonStyle(PrimaryButtonStyle())
            
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 40)
        .padding(.bottom, 20)
    }
    
    private func onContinue() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewView()
    }
}
