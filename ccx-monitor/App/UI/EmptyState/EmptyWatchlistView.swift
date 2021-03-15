//
//  EmptyWatchlistView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/15/21.
//

import SwiftUI

struct EmptyWatchlistView: View {
    var body: some View {
        HStack {
            Text("Tap")
            Image(systemName: Symbols.addToWatchlist)
            Text("to watch a coin")
        }
        .foregroundColor(.gullGray)
        .frame(maxWidth: .infinity)
    }
}
