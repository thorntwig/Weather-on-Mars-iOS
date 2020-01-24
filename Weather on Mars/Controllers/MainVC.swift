//
//  ViewController.swift
//  Weather on Mars
//
//  Created by Robin Törnqvist on 2020-01-13.
//  Copyright © 2020 Robin Törnqvist. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    let refreshControl = UIRefreshControl()
    let mainView = MainView()
    var solList = [Sol]()
    var indexPathRow: Int = 0
    var solObject: Sol? {
        didSet{
            guard let solNumber = self.solObject?.solNumber else { return }
            guard let solSeason = self.solObject?.season else { return }
            mainView.detailInfoLable.text = "Mars Sol. \(solNumber)"
            mainView.seasonLable.text = "Season: \(solSeason.firstUppercased)"
        }
    }
//     MARK: - Override functions
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
//     MARK: - Setup View
    
    func setup() {
        setupTableView()
        setupTapGeusture()
    }
    
    func setupTapGeusture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        mainView.pressureView.addGestureRecognizer(gesture)
        let windGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        mainView.windView.addGestureRecognizer(windGesture)
    }
    
    func setupTableView() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(getData), for: .valueChanged)
    }
    
    func setupLables(SolList: [Sol]) {
        
        let celcius = Sol.convertToCelsius(fahrenheit: SolList[0].at?.average ?? 0.0)
        setInfoLabels(for: 0, indexPath: 0)
        setInfoLabels(for: 1, indexPath: 0)
        mainView.tempLable.text = String(format: "%.f", celcius) + "°"
        
    }
    
//      MARK: functions
      
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
    
    @objc func getData() {
        let anonymousFunction = { (fetchedSolList: [Sol]) in
            DispatchQueue.main.async {
                self.solList = SolListUtility.sortByDate(solList: fetchedSolList)
                self.mainView.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.setupLables(SolList: self.solList)
                self.solObject = self.solList[0]
            }
        }
        SolAPI.shared.fetchSolList(router: Router.getInsightSols, onCompletion: anonymousFunction)
    }
    
    func setInfoLabels(for typeInt: Int, indexPath: Int) {
        switch typeInt {
        case 0:
            if let averageData = solList[indexPath].hws?.average {
                let averageString = String(format:"%.1f", averageData)
                let views = mainView.stackView.arrangedSubviews as! [InfoView]
                views[typeInt].setData(measureData: averageString + " m/s")
            }
        case 1:
            if let averageData = solList[indexPath].pre?.average {
                let averageString = String(format:"%.1f", averageData)
                let views = mainView.stackView.arrangedSubviews as! [InfoView]
                views[typeInt].setData(measureData: averageString + " Pa")
            }
        default:
            let views = mainView.stackView.arrangedSubviews as! [InfoView]
                views[typeInt].setData(measureData: " -- " + " -- ")
        }
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
            let celsius = Sol.convertToCelsius(fahrenheit: max)
            let maxString: String = String(format:"%.f", celsius)
            cell.maxLable.text = maxString
        }

        if let min = sol.at?.min {
            let celsius = Sol.convertToCelsius(fahrenheit: min)
            let minString: String = String(format:"%.f", celsius)
            cell.minLable.text = minString
        }


        if let av = sol.at?.average {
            let celsius = Sol.convertToCelsius(fahrenheit: av)
            let avString: String = String(format:"%.f", celsius)
            cell.averageLable.text = avString
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        cell.dateLable.text = dateFormatter.string(from: sol.firstUTC)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.solObject = solList[indexPath.row]
        if let av = solList[indexPath.row].at?.average {
            let celsius = Sol.convertToCelsius(fahrenheit: av)
            let avString: String = String(format:"%.f", celsius)
            mainView.tempLable.text = "\(avString)" + "°"
            indexPathRow = indexPath.row
            setInfoLabels(for: 0, indexPath: indexPath.row)
            setInfoLabels(for: 1, indexPath: indexPath.row)
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
