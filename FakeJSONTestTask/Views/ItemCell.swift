//
//  ItemCell.swift
//  FakeJSONTestTask
//
//  Created by Stanislav Makushov on 19.02.2023.
//

import UIKit

class ItemCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    var isAnimating: Bool {
        set { newValue ? activityIndicator.startAnimating() : activityIndicator.stopAnimating() }
        get { activityIndicator.isAnimating }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addViews()
        setupLayout()
        setupStyle()
    }
    
    private func addViews() {
        contentView.addSubviews(
            titleLabel,
            descriptionLabel,
            activityIndicator
        )
    }
    
    private func setupLayout() {
        titleLabel.layout {
            $0.top.equal(to: contentView.topAnchor, offsetBy: 8)
            $0.leading.equal(to: contentView.leadingAnchor, offsetBy: 16)
            $0.trailing.equal(to: activityIndicator.leadingAnchor, offsetBy: -16)
        }
        
        descriptionLabel.layout {
            $0.top.equal(to: titleLabel.bottomAnchor, offsetBy: 8)
            $0.leading.equal(to: contentView.leadingAnchor, offsetBy: 16)
            $0.trailing.equal(to: activityIndicator.leadingAnchor, offsetBy: -16)
            $0.bottom.equal(to: contentView.bottomAnchor, offsetBy: -8)
        }
        
        activityIndicator.layout {
            $0.centerY.equal(to: contentView.centerYAnchor)
            $0.trailing.equal(to: contentView.trailingAnchor, offsetBy: -16)
        }
    }
    
    private func setupStyle() {
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        titleLabel.numberOfLines = 0
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.numberOfLines = 0
        
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
    }
}
