//
//  SettingsView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/6/21.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = ViewModel()
        
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Watchlist")) {
                        if viewModel.watchlist.isEmpty {
                            EmptyWatchlistView()
                        } else {
                            ForEach(viewModel.watchlist, id: \.self) {
                                Text($0.name.capitalized)
                            }
                            .onDelete(perform: delete)
                        }
                    }
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(AppVersion.getCurrent())
                    }
                }
                
            }
            .navigationBarTitle("Settings")
            .listStyle(InsetGroupedListStyle())
        }
        .onAppear(perform: {
            viewModel.loadFromUserDefaults()
        })
    }
    
    private func delete(at offsets: IndexSet) {
        viewModel.delete(at: offsets)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
