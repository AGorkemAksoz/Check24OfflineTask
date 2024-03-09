//
//  Date+Extension.swift
//  Check24OfflineTask
//
//  Created by Ali Görkem Aksöz on 9.03.2024.
//

import Foundation

extension Date {
    init(productDateString: Int?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YY, MMM d"    
        let date = formatter.date(from: String(productDateString ?? 0)) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var medionFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en")
        return formatter
    }
    
    func asShortDatestring() -> String {
        return medionFormatter.string(from: self)
    }
}
