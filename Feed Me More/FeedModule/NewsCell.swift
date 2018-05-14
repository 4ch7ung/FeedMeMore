//
//  NewsCell.swift
//  Feed Me More
//
//  Created by macbook on 12.05.2018.
//  Copyright © 2018 4ch7ung. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    private let margin: CGFloat = 8
    private let spacing: CGFloat = 3
    
    private let dateFormatter: DateFormatter
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var feedNameLabel: UILabel!
    
    func createNewLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.titleLabel = createNewLabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        self.feedNameLabel = createNewLabel()
        feedNameLabel.font = UIFont.systemFont(ofSize: 7)
        feedNameLabel.textAlignment = .left
        feedNameLabel.baselineAdjustment = .alignCenters
        feedNameLabel.textColor = UIColor.darkGray
        
        self.dateLabel = createNewLabel()
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.textAlignment = .right
        dateLabel.textColor = UIColor.darkGray

        self.descriptionLabel = createNewLabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.lineBreakMode = .byTruncatingTail
        
        self.configureConstraints()
    }
    
    func configure(_ item: Item) {
        titleLabel.text = item.title
        feedNameLabel.text = item.feedName
        descriptionLabel.text = item.description
        dateLabel.text = dateFormatter.string(from: item.pubDate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin)
            ])
        
        NSLayoutConstraint.activate([
            feedNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            feedNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin)
            ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            dateLabel.leadingAnchor.constraint(equalTo: feedNameLabel.trailingAnchor, constant: spacing),
            dateLabel.widthAnchor.constraint(equalTo: feedNameLabel.widthAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin)
            ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: spacing),
            descriptionLabel.topAnchor.constraint(equalTo: feedNameLabel.bottomAnchor, constant: spacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin)
            ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            descriptionLabel.numberOfLines = 0
        } else {
            descriptionLabel.numberOfLines = 2
        }
    }
}
