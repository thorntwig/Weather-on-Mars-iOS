//
//  InfoView.swift
//  Weather on Mars
//
//  Created by Robin Törnqvist on 2020-01-20.
//  Copyright © 2020 Robin Törnqvist. All rights reserved.
//

import UIKit

class InfoView: UIView {
    var typeSwitcher: InfoType
    var measureLable = UILabel()
    var solClass: Sol?
    
    
    
    enum InfoType {
        case wind
        case pressure
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        self.typeSwitcher = .pressure
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
    }
    
    convenience init(frame: CGRect, type:InfoType) {
        self.init(frame: frame)
        self.solClass = solClass
        if #available(iOS 13.0, *) {
            backgroundColor = UIColor.secondarySystemBackground
        } else {
            
        }
        measureLable.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        switch type {
        case .wind:
            setupTypeView(type: "Wind", icon: "Wind-icon")
            self.typeSwitcher = .wind
            measureLable.text = "--" + " " + "m/s"
            self.tag = 1
        case .pressure:
            setupTypeView(type: "Pressure", icon: "Pressure-icon")
            self.typeSwitcher = .pressure
            measureLable.text = "--" + " " + "Pa"
            self.tag = 2
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let context = UIGraphicsGetCurrentContext() {
            switch typeSwitcher {
            case .wind:
                    context.setStrokeColor(UIColor(red:0.60, green:0.44, blue:0.94, alpha:1.0).cgColor)
            case .pressure:
                    context.setStrokeColor(UIColor(red:0.86, green:0.68, blue:0.72, alpha:1.0).cgColor)
            }
            
            context.setLineWidth(3)
            context.setLineCap(.round)
            context.move(to: CGPoint(x: 20, y: bounds.height / 9))
            context.addLine(to: CGPoint(x: bounds.width - 20, y: bounds.height / 9))
            context.strokePath()
        }
    }
    
    lazy var typeLable: UILabel = {
        let typeLable = UILabel()
        typeLable.translatesAutoresizingMaskIntoConstraints = false
        typeLable.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        typeLable.textAlignment = .center
        return typeLable
    }()
    
    lazy var typeIcon: UIImageView = {
        let typeIcon = UIImageView()
        
        typeIcon.translatesAutoresizingMaskIntoConstraints = false
        return typeIcon
    }()
    
    lazy var centerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [typeIcon, typeLable])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        return stackView
    }()
    
    
    func setupTypeView(type: String, icon:String) {
        addSubview(centerStackView)
        addSubview(measureLable)
        typeLable.text = type
        typeIcon.image = UIImage(named: icon)
        setupUILayout()
    }
    
    func setupUILayout() {
        measureLable.translatesAutoresizingMaskIntoConstraints = false
        centerStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        centerStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        typeIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        typeIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        measureLable.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        measureLable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    }
    
    func setData(measureData: String) {
        measureLable.text = measureData
    }
    
}
