//
//  StatisticList.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/24/21.
//

import SwiftUI

struct StatisticList: View {
    let title: String
    let statistics: [(name: String, value: String?)]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .sectionHeadline2Style()
                
            ForEach(statistics, id: \.0) { statistic in
                StatisticRow(title: statistic.name,
                             value: statistic.value)
            }
        }
    }
}

struct StatisticRow: View {
    let title: String
    let value: String?
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .foregroundColor(.gray)
                Spacer()
                Text(value ?? "-")
                    .fontWeight(.semibold)
            }
            .font(.caption)
            
            Divider()
        }
    }
}
