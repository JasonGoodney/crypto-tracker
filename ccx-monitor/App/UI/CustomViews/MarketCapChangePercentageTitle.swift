//
//  MarketCapChangePercentageTitle.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/3/21.
//

import SwiftUI

struct MarketCapChangePercentageTitle: View {
    
    private var percentage: Double
        
    init(percentage: Double) {
        self.percentage = percentage.decimals(2)
    }
    
    var percentageText: String {
        return "\(percentage)%".replacingOccurrences(of: "-", with: "")
    }
    
    var body: some View {
        Group {
            if percentage < 0 {
                Text("Market is down ")
                    + Text(percentageText)
                        .foregroundColor(.razzmattazz)
            } else if percentage > 0 {
                Text("Market is up ")
                    + Text(percentageText)
                        .foregroundColor(Color(.caribbeanGreen))
            } else {
                Text("Market is ")
                    + Text(percentageText)
                        .foregroundColor(Color(.regentGray))
            }
        }
        .font(Font.title.weight(.bold))
    }

}

struct MarketCapChangePercentageTitle_Previews: PreviewProvider {
    static var previews: some View {
        MarketCapChangePercentageTitle(percentage: 6.54332)
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
