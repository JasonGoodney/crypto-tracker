//
//  IconView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/13/21.
//

import SwiftUI

struct IconView: View {
    
    let image: String
    
    var body: some View {
        AsyncImage(url: URL(string: image)!,
                    placeholder: {
                        Image(Icon.logo.rawValue)
                            .resizable()
                    },
                    image: {
                        Image(uiImage: $0)
                            .resizable()
                    })
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView(image: Icon.logo.rawValue)
    }
}
