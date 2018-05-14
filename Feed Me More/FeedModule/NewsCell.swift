//
//  NewsCell.swift
//  Feed Me More
//
//  Created by macbook on 12.05.2018.
//  Copyright © 2018 4ch7ung. All rights reserved.
//

import UIKit
import Kingfisher

class NewsCell: UITableViewCell {
    private let margin: CGFloat = 8
    private let spacing: CGFloat = 3
    
    private let dateFormatter: DateFormatter
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var newImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var feedNameLabel: UILabel!
    
    var descriptionHeightConstraint: NSLayoutConstraint!
    
    private func createNewLabel(_ container: UIView) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        return label
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.dateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.headerView = UIView(frame: CGRect.zero)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerView)
        
        self.newImage = UIImageView()
        newImage.translatesAutoresizingMaskIntoConstraints = false
        newImage.contentMode = .scaleAspectFill
        newImage.layer.masksToBounds = true
        newImage.image = #imageLiteral(resourceName: "NoImage")
        headerView.addSubview(newImage)

        self.titleLabel = createNewLabel(headerView)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        self.feedNameLabel = createNewLabel(headerView)
        feedNameLabel.font = UIFont.systemFont(ofSize: 7)
        feedNameLabel.textAlignment = .left
        feedNameLabel.textColor = .darkGray
        
        self.dateLabel = createNewLabel(headerView)
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.textAlignment = .right
        dateLabel.textColor = .darkGray

        self.descriptionLabel = createNewLabel(contentView)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        
        self.configureConstraints()
    }
    
    func configure(_ item: Item) {
        newImage.image = #imageLiteral(resourceName: "NoImage")
        if let urlStr = item.imageUrl,
            let url = URL(string: urlStr) {
            
            newImage.kf.indicatorType = .activity
            newImage.kf.setImage(with: url)
        }
        titleLabel.text = item.title
        feedNameLabel.text = item.feedName
        descriptionLabel.text = item.description
        dateLabel.text = dateFormatter.string(from: item.pubDate)
    }
    
    /// Stop image download task
    func stopDownloadTasks() {
        newImage?.kf.cancelDownloadTask()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        // Header view on top, contains all but description
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            headerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 90)
            ])
        
        // Description is on bottom
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: spacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin)
            ])
        
        // And hidden by default
        descriptionHeightConstraint = descriptionLabel.heightAnchor.constraint(equalToConstant: 0)
        descriptionHeightConstraint.isActive = true
        
        // We do not want to use default imageView due to layout issues
        NSLayoutConstraint.activate([
            newImage.topAnchor.constraint(equalTo: headerView.topAnchor),
            newImage.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            newImage.widthAnchor.constraint(equalToConstant: 160),
            newImage.heightAnchor.constraint(equalToConstant: 90)
            ])
        
        // Title is on the left of the image
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: newImage.trailingAnchor, constant: spacing),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor)
            ])
        
        // Feed name is just right under the title
        NSLayoutConstraint.activate([
            feedNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            feedNameLabel.leadingAnchor.constraint(equalTo: newImage.trailingAnchor, constant: spacing)
            ])
        
        // Date is under the feed
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: feedNameLabel.bottomAnchor, constant: spacing),
            dateLabel.leadingAnchor.constraint(equalTo: newImage.trailingAnchor, constant: spacing),
            dateLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: headerView.bottomAnchor)
            ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        descriptionHeightConstraint.isActive = !selected
    }
}
