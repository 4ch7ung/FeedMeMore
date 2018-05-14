//
//  FeedViewModel.swift
//  Feed Me More
//
//  Created by macbook on 12.05.2018.
//  Copyright © 2018 4ch7ung. All rights reserved.
//

import Foundation

protocol FeedVMDelegate: class {
    func gotResults()
    func didFailToUpdateResults()
}

class FeedViewModel: FeedVM {
    private let apis: [FeedAPI]
    
    weak var delegate: FeedVMDelegate?
    var items: [Item]
    
    init(apis: [FeedAPI]) {
        self.items = []
        self.apis = apis
    }
    
    func updateFeed() {
        self.items = []
        for api in apis {
            api.requestFeed(success: { feed in
                self.mergeItems(feed.items)
                self.delegate?.gotResults()
            }, failure: { error in
                self.delegate?.didFailToUpdateResults()
                Logger.error(error.localizedDescription)
            })
        }
    }
    
    private func mergeItems(_ newItems: [Item]) {
        items.append(contentsOf: newItems)
        items.sort(by: { $0.pubDate > $1.pubDate })
    }
}
