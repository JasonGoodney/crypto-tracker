//
//  ListingRow.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/21/21.
//

import SwiftUI

struct ListingRow: View {
    let listing: CoinGecko.Coin
    
    // TODO: - Refactor
    let measure: String
    
    @State var offset = CGSize.zero
    @State var offsetY: CGFloat = 0
    @State var scale: CGFloat = 0.5
    
    @Environment(\.sizeCategory) var sizeCategory
    
    var marketCapText: String {
        if let marketCap = listing.marketCap {
            if marketCap == 0 {
                return "MCap $0.00"
            } else {
                return "MCap $\(marketCap.abbreviated)"
            }
        } else {
            return "MCap $0.00"
        }
    }
    
    var totalVolumeText: String { "24h Vol $\((listing.totalVolume ?? 0).abbreviated)" }
    
    var currentPriceText: String {
        if listing.currentPrice > 0.1 {
            return listing.currentPrice.toCurrency()
        } else {
            return "$\(listing.currentPrice)"
        }
    }
    
    func percentChangeValue(_ value: Double) -> Double {
        if abs(value) > 0.1 {
            return value.decimals(2)
        } else {
            return value
        }
    }
    
    init(listing: CoinGecko.Coin, measure: String = "Market Cap") {
        self.listing = listing
        self.measure = measure
    }

    var body: some View {
        VStack(alignment: .leading) {
            
            switch sizeCategory {
            case .accessibilityMedium,
                 .accessibilityLarge,
                 .accessibilityExtraLarge,
                 .accessibilityExtraExtraLarge,
                 .accessibilityExtraExtraExtraLarge:
                layoutForAccessibilitySizeCategories
            default:
                mainLayout
            }
                
            Divider()
        }
        .contentShape(Rectangle())
    }
    
    private var mainLayout: some View {
        HStack {
            iconView
                
            VStack(alignment: .leading, spacing: 4) {
                nameView
                    
                marketCapView
            }
                
            Spacer()
                
            VStack(alignment: .trailing, spacing: 4) {
                
                currentPriceView
                
                priceChangeView
            }
        }
    }
    
    private var layoutForAccessibilitySizeCategories: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 8) {
                iconView
                
                nameView
            }
                    
            marketCapView
                
            currentPriceView
            
            priceChangeView
        }
    }
    
    private var nameView: some View {
        Text(listing.name)
            .fontWeight(.black)
            .lineLimit(1)
            .padding(.trailing)
    }
    
    private var currentPriceView: some View {
        Text(currentPriceText)
            .fontWeight(.black)
    }
    
    private var priceChangeView: some View {
        Group {
            if let value = listing.priceChangePercentage24H {
                PercentChangeLabel(value: percentChangeValue(value))
            } else {
                Text("-")
                    .foregroundColor(.gullGray)
            }
        }
    }
    
    private var iconView: some View {
        Group {
            if let image = listing.image {
//                AsyncImage(url: URL(string: image)!,
//                           placeholder: {
//                               Image(systemName: "bitcoinsign.circle.fill")
//                                    .resizable()
//                                    .foregroundColor(.gullGray)
//                           },
//                           image: {
//                               Image(uiImage: $0)
//                                   .resizable()
//                           })
                AsyncImage(url: URL(string: image)!) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "bitcoinsign.circle.fill")
                     .resizable()
                }
                    .frame(width: 32, height: 32)
            }
        }
    }
    
    private var marketCapView: some View {
        Group {
            if measure == "Market Cap" {
                Text(marketCapText)
                    .font(.callout)
                    .bold()
                    .foregroundColor(.gullGray)
            } else if measure == "Volume" {
                Text(totalVolumeText)
                    .font(.callout)
                    .bold()
                    .foregroundColor(.gullGray)
            }
        }
    }

}

struct ListingRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ListingRow(listing: CoinGecko.Coin.example)
                .environment(\.sizeCategory, .extraSmall)
            
            ListingRow(listing: CoinGecko.Coin.example)
            
            ListingRow(listing: CoinGecko.Coin.example)
                .environment(\.sizeCategory, .accessibilityLarge)
            
            ListingRow(listing: CoinGecko.Coin.example)
                .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
            
            ListingRow(listing: CoinGecko.Coin.example)
                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        }
        .previewLayout(.sizeThatFits)
    }
}
