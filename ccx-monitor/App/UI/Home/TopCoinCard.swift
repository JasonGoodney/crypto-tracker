//
//  TopCoinCard.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/3/21.
//

import SwiftUI

extension View {
    
    func cardStyle(backgroundColor: Color = Color(UIColor.systemBackground),
                   width: CGFloat? = nil,
                   height: CGFloat? = nil) -> some View {
        
        self
            .padding()
            .font(.title)
            .background(backgroundColor)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            .contentShape(Rectangle())
    }
}

struct TopCoinCard: View {
    
    let coin: CoinGecko.Coin
    
    var showVolume = false
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.sizeCategory) var sizeCategory
    
    var backgroundColor: Color {
        return colorScheme == .dark
            ? Color(UIColor(red: 24/255, green: 25/255, blue: 28/255, alpha: 1))
            : Color(UIColor.systemBackground)
    }

    var body: some View {
            switch sizeCategory {
            case .accessibilityMedium,
                 .accessibilityLarge,
                 .accessibilityExtraLarge,
                 .accessibilityExtraExtraLarge,
                 .accessibilityExtraExtraExtraLarge:
                
                mainLayout
                    .frame(width: 300)
                    .cardStyle(backgroundColor: backgroundColor)
            default:
                mainLayout
                    .frame(width: 130, height: 160)
                    .cardStyle(backgroundColor: backgroundColor)

            }
    }
    
    private var mainLayout: some View {
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
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)
                    
                    Text("\(!showVolume ? coin.currentPrice.toCurrency() : (coin.totalVolume ?? 0).toCurrency())")
                        .font(.headline)
                        .layoutPriority(1)
                }
                Spacer()
                if let percentage = coin.priceChangePercentage24H {
                    PercentChangeLabel(value: percentage.decimals(2))
                }
            }
            Spacer()
        }
    }
}

struct TopCoinCard_Previews: PreviewProvider {
    static var previews: some View {
        TopCoinCard(coin: CoinGecko.Coin.example)
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
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
