//
//  ViewController.swift
//  Feed Me More
//
//  Created by macbook on 12.05.2018.
//  Copyright © 2018 4ch7ung. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var items: [Item] = []
    var parser: RssParser = StandardRssParser()
    
    override func viewDidLoad() {
        // TODO: move to networking
        let feedUrl = URL(string: "https://lenta.ru/rss/news")!
        let rss = try! Data(contentsOf: feedUrl)
        self.items = parser.parse(data: rss)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        
        let item = items[indexPath.row]
        cell.configure(item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.25) {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}

