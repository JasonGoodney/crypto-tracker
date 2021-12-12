//
//  BarButtonItem.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/17/21.
//

import SwiftUI

struct BarButtonItem: View {
    
    var text: String?
    
    var symbolName: String?
    
    var handleOnTap: () -> Void
    
    init(text: String,
         handleOnTap: @escaping () -> Void) {
        
        self.text = text
        self.handleOnTap = handleOnTap
    }
    
    init(symbolName: String,
         handleOnTap: @escaping () -> Void) {
        
        self.symbolName = symbolName
        self.handleOnTap = handleOnTap
    }
    
    var body: some View {
        Button(action: handleOnTap) {
            if let text = text {
                Text(text)
            } else if let symbolName = symbolName {
                Image(systemName: symbolName)
                    .resizable()
            }
        }
    }
}

struct BarButtonItem_Previews: PreviewProvider {
    static var previews: some View {
        BarButtonItem(text: "", handleOnTap: {})
    }
}
