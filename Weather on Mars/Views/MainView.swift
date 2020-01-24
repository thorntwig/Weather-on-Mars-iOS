//
//  MainView.swift
//  Weather on Mars
//
//  Created by Robin Törnqvist on 2020-01-24.
//  Copyright © 2020 Robin Törnqvist. All rights reserved.
//

import UIKit

class MainView: UIView {
    
    
    let pressureView = InfoView(frame: CGRect.zero, type: InfoView.InfoType.pressure)
    let windView = InfoView(frame: CGRect.zero, type: InfoView.InfoType.wind)

    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    lazy var seasonLable: UILabel = {
        let seasonLable = UILabel()
        seasonLable.translatesAutoresizingMaskIntoConstraints = false
        seasonLable.textColor = .white
     
        return seasonLable
    }()
    
    lazy var detailInfoLable: UILabel = {
        let detailInfoLable = UILabel()
        detailInfoLable.translatesAutoresizingMaskIntoConstraints = false
        detailInfoLable.textColor = .white
    
        
        return detailInfoLable
    }()
    
    lazy var maxLable: UILabel = {
        let maxLable = UILabel()
        maxLable.translatesAutoresizingMaskIntoConstraints = false
        maxLable.textColor = .lightGray
        maxLable.text = "Max"
        maxLable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        return maxLable
    }()
    
    lazy var dateLable: UILabel = {
        let dateLable = UILabel()
        dateLable.translatesAutoresizingMaskIntoConstraints = false
        dateLable.textColor = .lightGray
        dateLable.text = "Date"
        dateLable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        return dateLable
    }()
    
    lazy var aveLable: UILabel = {
        let aveLable = UILabel()
        aveLable.translatesAutoresizingMaskIntoConstraints = false
        aveLable.textColor = .lightGray
        aveLable.text = "Ave"
        aveLable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        return aveLable
    }()
    
    lazy var minLable: UILabel = {
        let minLable = UILabel()
        minLable.translatesAutoresizingMaskIntoConstraints = false
        minLable.textColor = .lightGray
        minLable.text = "Min"
        minLable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        return minLable
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [windView, pressureView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 20
        sv.distribution = .fillEqually
        
        return sv
    }()

    
    lazy var detailsLable: UILabel = {
        let dLable = UILabel()
        dLable.translatesAutoresizingMaskIntoConstraints = false
        dLable.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        dLable.text = "Details"
        
        return dLable
    }()
    
    lazy var placeLable: UILabel = {
        let placeLable = UILabel()
        placeLable.translatesAutoresizingMaskIntoConstraints = false
        placeLable.text = "Elysium Planitia, Mars"
        placeLable.textColor = .white
        placeLable.font = UIFont.systemFont(ofSize: 30, weight: .medium )
        
        return placeLable
    }()
    
    lazy var backgroundImage: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = UIImage(named: "Mars-background")
        backgroundImageView.contentMode = UIView.ContentMode.scaleAspectFill
        
        return backgroundImageView
    }()
    
    lazy var tempLable: UILabel = {
        let tempLable = UILabel()
        tempLable.translatesAutoresizingMaskIntoConstraints = false
        tempLable.textColor = .white
        tempLable.font = UIFont.systemFont(ofSize: 70, weight: .medium)
      
        return tempLable
    }()
    
    func setupInfoLables() {
        pressureView.layer.shadowColor = UIColor.black.cgColor
        pressureView.layer.shadowOpacity = 0.1
        pressureView.layer.shadowOffset = .zero
        pressureView.layer.shadowRadius = 10
              
        windView.layer.shadowColor = UIColor.black.cgColor
        windView.layer.shadowOpacity = 0.1
        windView.layer.shadowOffset = .zero
        windView.layer.shadowRadius = 10
              
    }
    
    func setupView() {
        addSubview(tableView)
        addSubview(backgroundImage)
        addSubview(seasonLable)
        addSubview(detailInfoLable)
        addSubview(maxLable)
        addSubview(dateLable)
        addSubview(aveLable)
        addSubview(minLable)
        addSubview(stackView)
        addSubview(detailsLable)
        addSubview(placeLable)
        addSubview(tempLable)
        
        
        tableView.register(SolCell.self, forCellReuseIdentifier: "cellid")
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.rowHeight = 45
        
        if #available(iOS 13.0, *) {
            backgroundColor = UIColor.systemBackground
        } else {
            
        }
        
    }
    
    func setupConstraints() {

        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 80),
            stackView.heightAnchor.constraint(equalToConstant: 80),
            
            detailsLable.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -11),
            detailsLable.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
            
            tableView.topAnchor.constraint(equalTo: centerYAnchor, constant: 100),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            maxLable.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            maxLable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            aveLable.trailingAnchor.constraint(equalTo: maxLable.leadingAnchor, constant: -10),
            aveLable.bottomAnchor.constraint(equalTo: maxLable.bottomAnchor),
            
            minLable.trailingAnchor.constraint(equalTo: aveLable.leadingAnchor, constant: -10),
            minLable.bottomAnchor.constraint(equalTo: maxLable.bottomAnchor),
            
            dateLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            dateLable.bottomAnchor.constraint(equalTo: maxLable.bottomAnchor),
            
            tempLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            tempLable.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height/6),
            
            placeLable.bottomAnchor.constraint(equalTo: tempLable.topAnchor, constant: 8),
            placeLable.leadingAnchor.constraint(equalTo: tempLable.leadingAnchor),
            
            backgroundImage.bottomAnchor.constraint(equalTo: detailsLable.topAnchor, constant: -10),
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            detailInfoLable.topAnchor.constraint(equalTo: tempLable.bottomAnchor, constant: -3),
            detailInfoLable.leadingAnchor.constraint(equalTo: tempLable.leadingAnchor),
            
            seasonLable.trailingAnchor.constraint(equalTo: placeLable.trailingAnchor),
            seasonLable.topAnchor.constraint(equalTo: placeLable.bottomAnchor)

            
            ])
    }
    


}
