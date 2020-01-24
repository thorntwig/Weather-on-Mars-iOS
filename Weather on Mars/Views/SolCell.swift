//
//  SolCell.swift
//  Weather on Mars
//
//  Created by Robin Törnqvist on 2020-01-15.
//  Copyright © 2020 Robin Törnqvist. All rights reserved.
//

import UIKit

class SolCell: UITableViewCell {
    var safeArea: UILayoutGuide!
    let maxLable = UILabel()
    let minLable = UILabel()
    let averageLable = UILabel()
    let dateLable = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupView() {
        safeArea = layoutMarginsGuide
        setupTextView()
    }
    
    func setupTextView() {
        addSubview(maxLable)
        addSubview(minLable)
        addSubview(averageLable)
        addSubview(dateLable)
        minLable.translatesAutoresizingMaskIntoConstraints = false
        maxLable.translatesAutoresizingMaskIntoConstraints = false
        averageLable.translatesAutoresizingMaskIntoConstraints = false
        dateLable.translatesAutoresizingMaskIntoConstraints = false
        
        dateLable.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        dateLable.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        maxLable.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        maxLable.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        maxLable.textColor = .red
        
        averageLable.trailingAnchor.constraint(equalTo: maxLable.leadingAnchor, constant: -5).isActive = true
        averageLable.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        minLable.trailingAnchor.constraint(equalTo: averageLable.leadingAnchor, constant: -5).isActive = true
        minLable.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        minLable.textColor = .blue
        
    }
}
