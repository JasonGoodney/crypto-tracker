//
//  HeaderInfoView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/27/21.
//

import SwiftUI

struct StatHeaderView: View {
    let headline: String
    let value: String
    let valueChange: Double?

    init(headline: String, value: String, valueChange: Double? = nil) {
        self.headline = headline
        self.value = value
        self.valueChange = valueChange
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(headline)
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundColor(Color(.regentGray))
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            if let valueChange = valueChange {
                PercentChangeLabel(value: valueChange.decimals(2))
            } else {
                Spacer()
            }
        }
    }
}

struct GlobalStatHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        StatHeaderView(headline: "Market Cap",
                       value: "1.47 T")
    }
}

extension Color {
    static let lightGray = Color(UIColor(red: 150/255, green: 166/255, blue: 182/255, alpha: 1))
    
    static let test = Color(UIColor.systemRed)
    
    static let caribbeanGreen = Color(.caribbeanGreen)
    
    static let razzmattazz = Color(.razzmattazz)
    
    static let woodsmoke = Color(.woodsmoke)
    
    static let regentGray = Color(.regentGray)
    
    static let mystic = Color(.mystic)
    
    static let gullGray = Color(.gullGray)
    
    static let dodgerBlue = Color(UIColor(red: 34/255, green: 149/255, blue: 242/255, alpha: 1))
}

extension UIColor {
    static let caribbeanGreen = UIColor(red: 2/255, green: 226/255, blue: 166/255, alpha: 1)
    
    static let razzmattazz = UIColor(red: 230/255, green: 3/255, blue: 87/255, alpha: 1)
    
    static let woodsmoke = UIColor(red: 6/255, green: 7/255, blue: 7/255, alpha: 1)
    
    static let regentGray = UIColor(red: 145/255, green: 159/255, blue: 171/255, alpha: 1)
    
    static let mystic = UIColor(red: 237/255, green: 241/255, blue: 244/255, alpha: 1)
    
    static let gullGray = UIColor(red: 151/255, green: 167/255, blue: 183/255, alpha: 1)
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded()/divisor
    }
}
