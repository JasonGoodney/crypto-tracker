//
//  NavigationBarTitleView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/28/21.
//

import SwiftUI

struct NavigationBarTitleView: View {
    
    private var todaysDate: String {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d"
            return dateFormatter.string(from: date)
        }
    
    var body: some View {
        VStack(alignment: .leading) {
//            Text("CCX Monitor")
//                .fontWeight(.black)
//
            Text(todaysDate)
                .font(.title)
                .fontWeight(.black)
                .foregroundColor(Color(.regentGray))
        }
    }
}

struct NavigationBarTitleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarTitleView()
    }
}
