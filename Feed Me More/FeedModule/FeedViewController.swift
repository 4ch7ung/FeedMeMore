//
//  FeedViewController.swift
//  Feed Me More
//
//  Created by macbook on 12.05.2018.
//  Copyright © 2018 4ch7ung. All rights reserved.
//

import UIKit

fileprivate struct Identifiers {
    static let newsCell = "NewsCell"
}

protocol FeedVM {
    var items: [Item] { get }
    
    func updateFeed()
}

class FeedViewController: UITableViewController {
    private let viewModel: FeedVM
    private var selectedIndexPath: IndexPath?
    
    init(viewModel: FeedVM) {
        self.viewModel = viewModel
        self.selectedIndexPath = nil
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        refresh()
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.estimatedRowHeight = 90
        tableView.register(NewsCell.self, forCellReuseIdentifier: Identifiers.newsCell)
    }
    
    @objc func refresh() {
        self.navigationItem.title = "Getting data..."
        viewModel.updateFeed()
    }
    
    func updateTableLayout() {
        UIView.animate(withDuration: 0.25) {
            self.tableView.beginUpdates()
            self.tableView.setNeedsLayout()
            self.tableView.endUpdates()
        }
    }
}

extension FeedViewController: FeedVMDelegate {
    func didFailToUpdateResults() {
        self.navigationItem.title = "Failed to get feed data"
        refreshControl?.endRefreshing()
    }
    
    func gotResults() {
        self.navigationItem.title = "News feed"
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
}

// MARK: - UITableViewDataSource
extension FeedViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.newsCell, for: indexPath) as! NewsCell
        
        let item = viewModel.items[indexPath.row]
        cell.configure(item)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FeedViewController {
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if selectedIndexPath == indexPath {
            tableView.deselectRow(at: indexPath, animated: true)
            self.updateTableLayout()
            selectedIndexPath = nil
            return nil
        }
        
        selectedIndexPath = indexPath
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let c = cell as? NewsCell else {
            Logger.debug("Cell is not typeof NewsCell")
            return
        }
        c.stopDownloadTasks()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.updateTableLayout()
    }
}
