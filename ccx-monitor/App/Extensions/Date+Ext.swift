//
//  Date+Ext.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/28/21.
//

import Foundation

extension Date {
    
    func format(as formatString: String) -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.string(from: date)
    }
    
    func dayDifference() -> String
    {
        let calendar = Calendar.current
//        let date = self //Date(timeIntervalSince1970: interval)
        let startOfNow = calendar.startOfDay(for: Date())
        let startOfTimeStamp = calendar.startOfDay(for: self)
        let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
        let day = components.day!
        if abs(day) < 2 {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            formatter.doesRelativeDateFormatting = true
            return formatter.string(from: self)
        } else if day > 1 {
            return "In \(day) days"
        } else {
            return self.format(as: "MMMM d")
        }
    }
}
