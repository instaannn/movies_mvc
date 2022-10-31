// DateFormatter+Extension.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

extension DateFormatter {
    static let dateLongFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "ru")
        return formatter
    }()

    static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ru")
        return formatter
    }()
}
