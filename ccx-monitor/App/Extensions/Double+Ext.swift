//
//  Double+Ext.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/22/21.
//

import Foundation

extension Double {
    func toCurrency(decimals: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = decimals
        formatter.locale = NSLocale.current
        return formatter.string(from: self as NSNumber) ?? ""
    }
    
    func toPercent(decimals: Int = 2) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.minimumFractionDigits = decimals
        numberFormatter.maximumFractionDigits = decimals
        return numberFormatter.string(from: self as NSNumber) ?? ""
    }
    
    func decimals(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    
    func shorted(decimals: Int = 0) -> String {
        if self >= 1_000_000_000 {
            return String(format: "%.2f B", Double(self / 1_000_000_000))
        } else if self >= 1_000_000 {
            return String(format: "%.2f M", Double(self / 1_000_000))
        }
        
//        if self >= 1000 && self < 10000 {
//            return String(format: "%.1fK", Double(self/100)/10).replacingOccurrences(of: ".0", with: "")
//        }
//
//        if self >= 10000 && self < 1000000 {
//            return "\(self/1000)k"
//        }
//
//        if self >= 1_000_000 && self < 10000000 {
//            return String(format: "%.1fM", Double(self/100000)/10).replacingOccurrences(of: ".0", with: "")
//        }
//
//        if self >= 10_000_000 {
//            return "\(self/1000000)M"
//        }

        return String(self)
    }
    
    var shortStringRepresentation: String {
        if self.isNaN {
            return "NaN"
        }
        if self.isInfinite {
            return "\(self < 0.0 ? "-" : "+")Infinity"
        }
        let units = ["", "k", "M", "B"]
        var interval = self
        var index = 0
        while index < units.count - 1 {
            if abs(interval) < 1000.0 {
                break
            }
            index += 1
            interval /= 1000.0
        }
        // + 2 to have one digit after the comma, + 1 to not have any.
        // Remove the * and the number of digits argument to display all the digits after the comma.
        return "\(String(format: "%0.*g", Int(log10(abs(interval))) + 2, interval)) \(units[index])"
    }
    
    var abbreviated: String {
        if self.isNaN {
            return "NaN"
        }
        if self.isInfinite {
            return "\(self < 0.0 ? "-" : "+")Infinity"
        }
        
        let units = ["", "k", "M", "B", "T"]
        
        var value = self
        
        var index = 0
        
        while value > 1_000 {
            value /= 1_000
            index += 1
        }
        
        return "\(value.decimals(2)) \(units[index])"
    }

    
}
