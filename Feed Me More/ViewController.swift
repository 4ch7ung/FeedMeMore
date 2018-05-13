//
//  ViewController.swift
//  Feed Me More
//
//  Created by macbook on 12.05.2018.
//  Copyright © 2018 4ch7ung. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    // TODO: Move stuff to model
    var items: [Item] = []
    private var api: FeedAPI = LentaRuFeedAPIFactory().createAPI()
    
    override func viewDidLoad() {
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
    }
    
    @objc func refresh() {
        // TODO: move to networking
        self.navigationItem.title = "Getting data..."
        api.requestFeed(success: { feed in
            self.navigationItem.title = "Lenta.ru feed"
            self.gotResults(feed.items)
        }, failure: { error in
            self.navigationItem.title = "Failed to get feed data"
            self.didFailToUpdateResults()
            NSLog("\(error.localizedDescription)")
        })
    }
    
    func didFailToUpdateResults() {
    }
    
    func gotResults(_ items: [Item]) {
        self.items = items
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        
        let item = items[indexPath.row]
        cell.configure(item)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.25) {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}
