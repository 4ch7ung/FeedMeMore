//
//  FeedViewModel.swift
//  Feed Me More
//
//  Created by macbook on 12.05.2018.
//  Copyright © 2018 4ch7ung. All rights reserved.
//

import Foundation

protocol FeedVMDelegate {
    func gotResults()
    func didFailToUpdateResults()
}

class FeedViewModel: FeedVM {
    private let api: FeedAPI
    
    var delegate: FeedVMDelegate?
    var items: [Item]
    
    init(api: FeedAPI) {
        self.items = []
        self.api = api
    }
    
    func updateFeed() {
        api.requestFeed(success: { feed in
            self.items = feed.items
            self.delegate?.gotResults()
        }, failure: { error in
            self.delegate?.didFailToUpdateResults()
            NSLog("\(error.localizedDescription)")
        })
    }
}
