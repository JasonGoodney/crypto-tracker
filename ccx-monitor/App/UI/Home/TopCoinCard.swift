//
//  TopCoinCard.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/3/21.
//

import SwiftUI

struct TopCoinCard: View {
    
    let coin: CoinGecko.CoinMarketData
    
    var showVolume = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if let imageUrl = coin.image {
                    IconView(image: imageUrl)
                        .frame(width: 32, height: 32)
                }
                Spacer()
                VStack(alignment: .leading, spacing: 4) {
                    Text(coin.name)
                        .font(.title3)
                        .lineLimit(1)
                    Text("\(!showVolume ? coin.currentPrice.toCurrency() : (coin.totalVolume ?? 0).toCurrency())")
                        .font(.headline)
                }
                Spacer()
                if let percentage = coin.priceChangePercentage24H {
                    PercentChangeLabel(value: percentage.decimals(2))
                }
            }
            
            Spacer()
        }
        .frame(width: 130, height: 160)
        .padding()
        .font(.title)
        .background(colorScheme == .dark
                        ? Color(UIColor(red: 24/255, green: 25/255, blue: 28/255, alpha: 1))
                        : Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .contentShape(Rectangle())
    }
}

struct TopCoinCard_Previews: PreviewProvider {
    static var previews: some View {
        TopCoinCard(coin: CoinGecko.CoinMarketData.default)
    }
}

struct ShadowCardStyle: CardStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.title)
      .foregroundColor(.black)
      .padding()
      .background(Color.white.cornerRadius(16))
      .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
  }
}

protocol CardStyle {
  associatedtype Body: View
  typealias Configuration = CardStyleConfiguration

  func makeBody(configuration: Self.Configuration) -> Self.Body
}

struct CardStyleConfiguration {
  /// A type-erased label of a Card.
  struct Label: View {
    init<Content: View>(content: Content) {
      body = AnyView(content)
    }

    var body: AnyView
  }

  let label: CardStyleConfiguration.Label
}
