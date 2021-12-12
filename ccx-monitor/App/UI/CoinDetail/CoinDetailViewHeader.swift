//
//  CoinDetailViewHeader.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/27/21.
//

import SwiftUI

struct CoinDetailViewHeader: View {
    let coin: CoinGecko.Coin
    @Binding var backgroundColor: Color
    
    @State var timer = Timer.publish(every: 0.1, on: .current, in: .tracking).autoconnect()
    @State var show = false
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .foregroundColor(backgroundColor)
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .cornerRadius(50, corners: [.bottomLeft, .bottomRight])
                    
                    VStack {
                        HStack {
                            icon
                                .frame(width: 32, height: 32)
                            
                            Text(coin.name)
                            
                            Spacer()
                        }
                    }
                }
                .offset(y: geometry.frame(in: .global).minY > 0
                    ? -geometry.frame(in: .global).minY : 0)
                .frame(height: geometry.frame(in: .global).minY > 0
                        ? UIScreen.main.bounds.height / 2.2 + geometry.frame(in: .global).minY
                        : UIScreen.main.bounds.height / 2.2)
                .onReceive(timer, perform: { _ in
                    let y = geometry.frame(in: .global).minY
                    
                    if -y > (UIScreen.main.bounds.height / 2.2) - 50 {
                        show = true
                        print("hello world")
                    } else { show = false }
                })
            }
            .frame(height: UIScreen.main.bounds.height / 2.2)
            
            if show {
                HStack {
                    icon
                        .frame(width: 32, height: 32)
                    
                    Text(coin.name)
                    
                    Spacer()
                    
                    
                }
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top == 0
                         ? 15 : (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 5)
            }
        }
    }
    
    private var icon: some View {
        
//            AsyncImage(url: URL(string: coin.image!)!,
//                       placeholder: {
//                           Image(systemName: "bitcoinsign.circle.fill").resizable()
//                       },
//                       image: {
//                           Image(uiImage: $0).resizable()
//                       },
//                       onAppeared: { image in
//                           setAverageColor(from: image)
//                       })
        AsyncImage(url: URL(string: coin.image!)!, scale: 2) { image in
                    image.resizable()
                        .onAppear {
                            setAverageColor(from: image.asUIImage())
                        }
                } placeholder: {
                    Image(systemName: "bitcoinsign.circle.fill")
                     .resizable()
                }
                .scaledToFill()
                .clipShape(Rectangle())
                .frame(maxWidth: .infinity, maxHeight: 44)
                .onAppear()
        
    }

    private func setAverageColor(from image: UIImage) {
        let uiColor = image.averageColor ?? .clear
        backgroundColor = Color(uiColor)
    }
    
    private var name: some View {
        
            Text(coin.name)
                .bold()
                .shadow(color: Color.gray,
                        radius: 1.0)
        
    }

}

struct CoinDetailViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailViewHeader(coin: CoinGecko.Coin.example,
                             backgroundColor: .constant(.dodgerBlue))
            .previewLayout(.sizeThatFits)
    }
}

