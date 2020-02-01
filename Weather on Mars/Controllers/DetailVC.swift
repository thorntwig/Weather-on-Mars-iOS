//
//  DetailVCViewController.swift
//  Weather on Mars
//
//  Created by Robin Törnqvist on 2020-01-21.
//  Copyright © 2020 Robin Törnqvist. All rights reserved.
//

import UIKit
import Charts

class DetailVC: UIViewController {
    
    var sols: [Sol]?
    var indexPathRow: Int?
    var type: InfoView.InfoType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChart(solList: sols)
        setupView()
        setupBarChartView()
    }
    
    lazy var lineChartView: LineChartView = {
        let lineChartView = LineChartView()
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        
        return lineChartView
    }()
    
    func setChart(solList: [Sol]?) {
        
        guard let solList = solList else { return }
        var dateArray = [Date]()
        var atArray = [At]()
        for sol in solList {
            dateArray.append(sol.firstUTC)

            switch type {
            case .wind:
                guard let hws = sol.hws else { return }
                atArray.append(hws)
            case .pressure:
                guard let pre = sol.pre else { return }
                atArray.append(pre)
            case .none:
                return
            }
        }
        let average = (0..<atArray.count).map { (i) -> ChartDataEntry in
            if let val = atArray[i].average {
                return ChartDataEntry(x: Double(i), y: val)
            }
            return ChartDataEntry()
        }
        
        let min = (0..<atArray.count).map { (i) -> ChartDataEntry in
            if let val = atArray[i].min {
                return ChartDataEntry(x: Double(i), y: val)
            }
            return ChartDataEntry()
        }
        let max = (0..<atArray.count).map { (i) -> ChartDataEntry in
            if let val = atArray[i].max {
                return ChartDataEntry(x: Double(i), y: val)
            }
            return ChartDataEntry()
        }
        var dataSets = [LineChartDataSet]()
        
        dataSets.append(LineChartDataSet(entries: average, label: "Average"))
        dataSets.append(LineChartDataSet(entries: min, label: "Min"))
        dataSets.append(LineChartDataSet(entries: max, label: "Max"))
        dataSets[0].colors = [UIColor(ciColor: .black)]
        dataSets[1].colors = [UIColor(ciColor: .red)]
        dataSets[2].colors = [UIColor(ciColor: .green)]
        
        for dataSet in dataSets {
            dataSet.highlightEnabled = true
            dataSet.highlightColor = UIColor(ciColor: .black)
        }
        let data = LineChartData(dataSets: dataSets)
        self.lineChartView.data = data
        if let indexPathRowTest = self.indexPathRow {
            self.lineChartView.highlightValue(x: Double(indexPathRowTest),y: Double.nan, dataSetIndex: 0)
        }
    }
    
    func setupView() {
        view.backgroundColor = .white
        switch type {
        case .wind:
            self.title = "Wind"
        case .pressure:
            self.title = "Pressure"
        case .none:
            return
        }
    }
    
    func setupBarChartView() {
        view.addSubview(lineChartView)
        NSLayoutConstraint.activate([
          lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          lineChartView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
          lineChartView.bottomAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
