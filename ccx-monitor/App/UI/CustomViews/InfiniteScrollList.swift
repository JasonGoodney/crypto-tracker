//
//  InfiniteScrollList.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/28/21.
//

import SwiftUI

struct InfiniteScrollList<T, Content>: View where T: Identifiable, T: Equatable, Content: View {
    @Environment(\.presentationMode) var presentationMode
    
    let content: (T) -> Content
    var items: [T] = []
    var itemLimitReached: Bool
    let isLoading: Bool
    let onScrolledAtBottom: () -> Void
    var onRowTapped: ((T) -> Void)?
    
    @GestureState private var isDragging = false
    
    init(items: [T],
         itemLimitReached: Bool = false,
         isLoading: Bool,
         onScrolledAtBottom: @escaping () -> Void,
         onRowTapped: ((T) -> Void)? = nil,
         @ViewBuilder content: @escaping (T) -> Content) {
        self.items = items
        self.itemLimitReached = itemLimitReached
        self.isLoading = isLoading
        self.onScrolledAtBottom = onScrolledAtBottom
        self.onRowTapped = onRowTapped
        self.content = content
    }
    
    var body: some View {
        Group {
            itemsList
            if isLoading {
                loadingIndicator
            }
            
            if itemLimitReached {
                Text("You've reached the end :(")
            }
        }
    }
    
    private var itemsList: some View {
        LazyVStack {
            ForEach(items) { item in
                content(item)
                    .onAppear {
                        if items[items.count - 5] == item {
                            onScrolledAtBottom()
                        }
                    }
                    .onTapGesture(perform: {
                        onRowTapped?(item)
                    })
            }
        }
    }

    private var loadingIndicator: some View {
        Spinner(style: .medium)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}
