//
//  Sheet.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/8/21.
//

import SwiftUI
import  BetterSafariView

struct Sheet: View {
    enum SheetType: Identifiable {
        case safari(URL)
        
        var id: String {
            switch self {
            case .safari(let url):
                return url.absoluteString
            }
        }
    }
    
    let sheetType: SheetType
    
    @ViewBuilder
    var body: some View {
        switch sheetType {
        case .safari(let url):
            SafariView(url: url)
        }
    }
}
