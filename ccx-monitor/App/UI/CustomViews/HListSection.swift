//
//  HListSection.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/14/21.
//

import SwiftUI

struct HListSection<T, Content>: View where T: Identifiable, Content: View {
    
    let title: String
    let items: [T]
    let content: (T) -> Content
    
    init(
        title: String,
        items: [T],
        @ViewBuilder content: @escaping (T) -> Content) {
        
        self.title      = title
        self.items      = items
        self.content    = content
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .sectionTitleStyle()

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(items) {
                        content($0)
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding(.bottom)
        }
    }
}
