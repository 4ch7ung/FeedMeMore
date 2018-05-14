//
//  RFC822DateFormatter.swift
//  Feed Me More
//
//  Created by macbook on 14.05.2018.
//  Copyright © 2018 4ch7ung. All rights reserved.
//

import Foundation

/// RFC822 date formatting wrapper
/// Warning! This class is not a full implementation of DateFormatter API
/// Only date(from: String) and string(from: Date) are implemented
class RFC822DateFormatter: DateFormatter {
    private let internalFormatter: DateFormatter
    
    override init() {
        self.internalFormatter = DateFormatter()
        super.init()
        configureFormatter()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.internalFormatter = DateFormatter()
        super.init(coder: aDecoder)
        configureFormatter()
    }
    
    private func configureFormatter() {
        internalFormatter.locale = Locale(identifier: "en_US")
        internalFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
    }
    
    override func date(from string: String) -> Date? {
        return internalFormatter.date(from: string)
    }
    
    override func string(from date: Date) -> String {
        return internalFormatter.string(from: date)
    }
}
