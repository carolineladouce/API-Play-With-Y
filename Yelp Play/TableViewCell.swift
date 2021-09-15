//
//  TableViewCell.swift
//  Yelp Play
//
//  Created by Caroline LaDouce on 9/6/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    var safeArea: UILayoutGuide!
    
    let iconImageView = UIImageView()
    let restaurantTitleLabel = UILabel()
    let priceRangeLabel = UILabel()
    let distanceLabel = UILabel()
    let priceDistanceSeparatorLabel = UILabel()
    let arrowImageView = UIImageView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        safeArea = contentView.layoutMarginsGuide
        setupIconImageView()
        setupRestaurantTitleLabel()
        setupPriceRangeLabel()
        setupPriceDistanceSeparatorLabel()
        setupDistanceLabel()
    }
    
    
    func setupIconImageView() {
        contentView.addSubview(iconImageView)
        
        // set constraints
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true

    }
    
    
    func setupRestaurantTitleLabel() {
        contentView.addSubview(restaurantTitleLabel)
        
        // set constraints
        restaurantTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        restaurantTitleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        restaurantTitleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10).isActive = true
        restaurantTitleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -50).isActive = true
        
        restaurantTitleLabel.numberOfLines = 0
    }
    
    
    func setupPriceRangeLabel() {
        contentView.addSubview(priceRangeLabel)
        
        // set constraints
        priceRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        priceRangeLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10).isActive = true
        priceRangeLabel.topAnchor.constraint(equalTo: restaurantTitleLabel.bottomAnchor, constant: 5).isActive = true
        priceRangeLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
    
    
    func setupDistanceLabel() {
        contentView.addSubview(distanceLabel)
        
        // set constraints
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.leadingAnchor.constraint(equalTo: priceDistanceSeparatorLabel.trailingAnchor, constant: 10).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: restaurantTitleLabel.bottomAnchor, constant: 5).isActive = true
        distanceLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
    
    
    func setupPriceDistanceSeparatorLabel() {
        contentView.addSubview(priceDistanceSeparatorLabel)
        
        // set constraints
        priceDistanceSeparatorLabel.translatesAutoresizingMaskIntoConstraints = false
        priceDistanceSeparatorLabel.leadingAnchor.constraint(equalTo: priceRangeLabel.trailingAnchor, constant: 10).isActive = true
        priceDistanceSeparatorLabel.topAnchor.constraint(equalTo: restaurantTitleLabel.bottomAnchor, constant: 5).isActive = true
        
    }
    
} // End class
