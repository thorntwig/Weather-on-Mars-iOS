//
//  ViewController.swift
//  Weather on Mars
//
//  Created by Robin Törnqvist on 2020-01-13.
//  Copyright © 2020 Robin Törnqvist. All rights reserved.
//

import UIKit
import SkeletonView

class MainVC: UIViewController {
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    var solList = [SolClass]()
    let pressureView = InfoView(frame: CGRect.zero, type: InfoView.InfoType.pressure)
    let windView = InfoView(frame: CGRect.zero, type: InfoView.InfoType.wind)
    var tempLable = UILabel()
    var indexPathRow: Int = 0
    
    var solObject: SolClass? {
        didSet{
            guard let solNumber = self.solObject?.solNumber else { return }
            guard let solSeason = self.solObject?.season else { return }
            detailInfoLable.text = "Mars Sol. \(solNumber)"
            seasonLable.text = "Season: \(solSeason.firstUppercased)"
        }
    }
//     MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData()
        view.bringSubviewToFront(maxLable)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
//     MARK: - Fields
    
    lazy var refreshControll: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    @objc func refresh(sender:AnyObject) {
        getData()
    }
    
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
    
    @objc func tap(_ sender:UITapGestureRecognizer) {
        let detailVC = DetailVC()
        detailVC.indexPathRow = self.indexPathRow
        detailVC.sols = solList
        switch sender.view!.tag {
        case 1:
            detailVC.type = InfoView.InfoType.wind
        case 2:
            detailVC.type = InfoView.InfoType.pressure
        default:
            return
        }
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
//     MARK: - Setup View
    
    func setup() {
        safeArea = view.layoutMarginsGuide
        view.addSubview(backgroundImage)
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            
        }
        self.navigationItem.title = "Weather on Mars"
        setupStackViews()
        setupTableView()
        setupTapGeusture()
        setupInfoLables()
       
    }
    
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
    

    func setupStackViews() {
        view.addSubview(stackView)
        view.addSubview(detailsLable)
        NSLayoutConstraint.activate([
            
            //stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 80),
            stackView.heightAnchor.constraint(equalToConstant: 80),
            detailsLable.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -11),
            detailsLable.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20)
            ])
    }
    
    func setupTapGeusture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.pressureView.addGestureRecognizer(gesture)
        let windGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.windView.addGestureRecognizer(windGesture)
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.refreshControl = refreshControll
        tableView.register(SolCell.self, forCellReuseIdentifier: "cellid")
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: 100).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.rowHeight = 45
        

    }
    
    func setupLables(SolList: [SolClass]) {
        view.addSubview(tempLable)
        view.addSubview(placeLable)
        view.addSubview(detailInfoLable)
        view.addSubview(seasonLable)
        view.addSubview(maxLable)
        view.addSubview(aveLable)
        view.addSubview(minLable)
        view.addSubview(dateLable)
        
        maxLable.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        maxLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        aveLable.trailingAnchor.constraint(equalTo: maxLable.leadingAnchor, constant: -10).isActive = true
        aveLable.bottomAnchor.constraint(equalTo: maxLable.bottomAnchor).isActive = true
        
        minLable.trailingAnchor.constraint(equalTo: aveLable.leadingAnchor, constant: -10).isActive = true
        minLable.bottomAnchor.constraint(equalTo: maxLable.bottomAnchor).isActive = true
        
        dateLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        dateLable.bottomAnchor.constraint(equalTo: maxLable.bottomAnchor).isActive = true
        
        let celcius = SolClass.convertToCelsius(fahrenheit: SolList[0].at?.average ?? 0.0)
        setInfoLabels(for: 0, indexPath: 0)
        setInfoLabels(for: 1, indexPath: 0)
        tempLable.text = String(format: "%.f", celcius) + "°"
        tempLable.textColor = .white
        tempLable.font = UIFont.systemFont(ofSize: 70, weight: .medium)
        tempLable.translatesAutoresizingMaskIntoConstraints = false
        tempLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        tempLable.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: UIScreen.main.bounds.height/9).isActive = true
        placeLable.bottomAnchor.constraint(equalTo: tempLable.topAnchor, constant: 8).isActive = true
        placeLable.leadingAnchor.constraint(equalTo: tempLable.leadingAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: detailsLable.topAnchor, constant: -10).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        detailInfoLable.topAnchor.constraint(equalTo: tempLable.bottomAnchor, constant: -3).isActive = true
        detailInfoLable.leadingAnchor.constraint(equalTo: tempLable.leadingAnchor).isActive = true
        seasonLable.trailingAnchor.constraint(equalTo: placeLable.trailingAnchor).isActive = true
        seasonLable.topAnchor.constraint(equalTo: placeLable.bottomAnchor).isActive = true

    }
    
    func getData() {
        let anonymousFunction = { (fetchedSolList: [SolClass]) in
            DispatchQueue.main.async {
                self.solList = fetchedSolList
                self.refreshControll.endRefreshing()
                self.tableView.reloadData()
                self.setupLables(SolList: self.solList)
                self.solObject = self.solList[0]
                
            }
            
        }
        SolAPI.shared.fetchSolList(router: Router.getInsightSols, onCompletion: anonymousFunction)
    }
}
//        MARK: - UITableViewDataSource

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return solList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath) as! SolCell
        let sol = solList[indexPath.row]
        if let max = sol.at?.max {
            let celsius = SolClass.convertToCelsius(fahrenheit: max)
            let maxString: String = String(format:"%.f", celsius)
            cell.maxLable.text = maxString
        }

        if let min = sol.at?.min {
            let celsius = SolClass.convertToCelsius(fahrenheit: min)
            let minString: String = String(format:"%.f", celsius)
            cell.minLable.text = minString
        }


        if let av = sol.at?.average {
            let celsius = SolClass.convertToCelsius(fahrenheit: av)
            let avString: String = String(format:"%.f", celsius)
            cell.averageLable.text = avString
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        cell.dateLable.text = dateFormatter.string(from: sol.firstUTC)
        cell.isSkeletonable = true
        
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.solObject = solList[indexPath.row]
        if let av = solList[indexPath.row].at?.average {
            let celsius = SolClass.convertToCelsius(fahrenheit: av)
            let avString: String = String(format:"%.f", celsius)
            tempLable.text = "\(avString)" + "°"
            indexPathRow = indexPath.row
            setInfoLabels(for: 0, indexPath: indexPath.row)
            setInfoLabels(for: 1, indexPath: indexPath.row)
        }
    }
    
    func setInfoLabels(for typeInt: Int, indexPath: Int) {
        switch typeInt {
        case 0:
            if let averageData = solList[indexPath].hws?.average {
                let averageString = String(format:"%.1f", averageData)
                let views = stackView.arrangedSubviews as! [InfoView]
                views[typeInt].setData(measureData: averageString + " m/s")
            }
        case 1:
            if let averageData = solList[indexPath].pre?.average {
                let averageString = String(format:"%.1f", averageData)
                let views = stackView.arrangedSubviews as! [InfoView]
                views[typeInt].setData(measureData: averageString + " Pa")
            }
        default:
            let views = stackView.arrangedSubviews as! [InfoView]
                views[typeInt].setData(measureData: " -- " + " -- ")
        }
    }
}

// MARK: - String Extension

extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }
}
