//
//  Item.swift
//  Feed Me More
//
//  Created by macbook on 14.05.2018.
//  Copyright © 2018 4ch7ung. All rights reserved.
//

import Foundation

/// News item representing single new
struct Item {
    var feedName: String = ""
    var title: String = ""
    var description: String = ""
    var imageUrl: String? = nil
    var pubDate: Date = Date()
}
