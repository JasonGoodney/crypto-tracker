//
//  CoinDetailHeroView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/28/21.
//

import SwiftUI

struct CoinDetailHeroView: View {
    
    let coin: CoinGecko.Coin
    
    @Binding var showTopView: Bool
    
    @State var backgroundColor: Color = .dodgerBlue
    
    @State var event = Timer.publish(every: 0.1,
                                     on: .current,
                                     in: .tracking).autoconnect()

    var heroHeightDenominator: CGFloat = 3
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                Rectangle()
                    .foregroundColor(backgroundColor.opacity(0.6))
                    .cornerRadius(50, corners: [.bottomLeft, .bottomRight])
                
                VStack {
                    Spacer()
                    icon
                    name
                    Spacer()
                }
            }
            .offset(y: geometry.frame(in: .global).minY > 0
                ? -geometry.frame(in: .global).minY : 0)
            .frame(height: geometry.frame(in: .global).minY > 0
                    ? UIScreen.main.bounds.height / heroHeightDenominator + geometry.frame(in: .global).minY
                    : UIScreen.main.bounds.height / heroHeightDenominator)
            .onReceive(event, perform: { _ in
                let y = geometry.frame(in: .global).minY
                if -y > (UIScreen.main.bounds.height / heroHeightDenominator) - 100 {
                    withAnimation { showTopView = true }
                    // -279.3333333333333 333.6363636363636
                } else {
                    withAnimation { showTopView = false }
                }
            })
        }
        .shadow(color: Color(UIColor.label).opacity(0.2), radius: 8, x: 0, y: 4)
        .frame(height: UIScreen.main.bounds.height / heroHeightDenominator)
    }
    
    private var icon: some View {
        AsyncImage(url: URL(string: coin.image!)!, scale: 2) { image in
            image.resizable()
                .onAppear {
                    setAverageColor(from: image.asUIImage())
                }
        } placeholder: {
            Image(systemName: "bitcoinsign.circle.fill")
             .resizable()
        }
        .frame(width: 128, height: 128)

//            AsyncImage(url: URL(string: coin.image!)!,
//                       placeholder: {
//                           Image(systemName: "bitcoinsign.circle.fill")
//                            .resizable()
//                       },
//                       image: {
//                           Image(uiImage: $0)
//                            .resizable()
//                       },
//                       onAppeared: { image in
//                           setAverageColor(from: image)
//                       })
//                .frame(width: 128, height: 64)
        
    }

    private var name: some View {
        
            Text(coin.name)
                .bold()
                .font(.system(size: 50))
                .shadow(color: Color.gray,
                        radius: 1.0)
        
    }
    
    private func setAverageColor(from image: UIImage) {
        backgroundColor = Color(image.averageColor!)
    }
}

struct CoinDetailHeroView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailHeroView(
            coin: CoinGecko.Coin.example,
            showTopView: .constant(false))
    }
}
