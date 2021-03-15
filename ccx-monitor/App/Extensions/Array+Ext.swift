//
//  Array+Ext.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/14/21.
//

import Foundation

extension Array {
    mutating func addElements(upTo index: Int, from newElements: [Self.Element]) {
        if newElements.count < index {
            self.append(contentsOf: newElements)
        } else {
            self.append(contentsOf: Array(newElements[0..<index]))
        }
    }
}
