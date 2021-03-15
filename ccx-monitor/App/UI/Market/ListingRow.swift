//
//  ListingRow.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/21/21.
//

import SwiftUI

struct ListingRow: View {
    
    let listing: CoinGecko.CoinMarketData
    
    // TODO: - Refactor
    let measure: String
    
    @State var offset = CGSize.zero
    @State var offsetY : CGFloat = 0
    @State var scale : CGFloat = 0.5
    
    init(listing: CoinGecko.CoinMarketData, measure: String = "Market Cap") {
        self.listing = listing
        self.measure = measure
    }

    var body: some View {
        
            VStack{
                HStack {
                    if let image = listing.image {
                        AsyncImage(url: URL(string: image)!,
                                    placeholder: {
                                            Image(systemName: "bitcoinsign.circle.fill")
                                                .resizable()
                                                .foregroundColor(.gullGray)
                                    },
                                    image: {
                                            Image(uiImage: $0)
                                                .resizable()
                                    })
                            .frame(width: 32, height: 32)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(listing.name)
                            .fontWeight(.black)
                            .lineLimit(1)
                            .padding(.trailing)
                        
                        if measure == "Market Cap" {
                        Text("MCap $\((listing.marketCap ?? 0).abbreviated)")
                            .font(.callout)
                            .bold()
                            .foregroundColor(.gullGray)
                        } else if measure == "Volume" {
                            Text("Volume $\((listing.totalVolume ?? 0).abbreviated)")
                                .font(.callout)
                                .bold()
                                .foregroundColor(.gullGray)
                        }
                            
                        
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(listing.currentPrice.toCurrency())
                            .fontWeight(.black)

                        
                        if let value = listing.priceChangePercentage24H {
                            PercentChangeLabel(value: value.decimals(2))
                        } else {
                            Spacer()
                        }
                    }
                }
                
                Divider()
            }
            .contentShape(Rectangle())
         
    }
}

struct ListingRow_Previews: PreviewProvider {
    static var previews: some View {
        ListingRow(listing: CoinGecko.CoinMarketData.default)
    }
}
