//
//  PointsViewController.swift
//  HackMIT-iOS
//
//  Created by Emmie Ohnuki on 9/15/19.
//  Copyright © 2019 Emmie Ohnuki. All rights reserved.
//

import UIKit
import Charts

class PointsViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setup(barLineChartView: barChartView)
        
       
        
        barChartView.chartDescription?.enabled = false
        barChartView.maxVisibleCount = 60
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        
        barChartView.rightAxis.drawLabelsEnabled = false
        
        barChartView.legend.enabled = false
        
        setDataCount(6, range: 100)
    }
    
    func updateChartData() {
        
    }
    
    func setDataCount(_ count: Int, range: Double) {
        let yVals = (1..<count).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(UInt32(mult))) + mult/3
            return BarChartDataEntry(x: Double(i), y: val)
        }
        
        var set1: BarChartDataSet! = nil
        if let set = barChartView.data?.dataSets.first as? BarChartDataSet {
            set1 = set
            //set1?.replaceEntries(yVals)
            barChartView.data?.notifyDataChanged()
            barChartView.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(values: yVals, label: "Data Set")
            set1.colors = ChartColorTemplates.vordiplom()
            set1.drawValuesEnabled = false
            
            let data = BarChartData(dataSet: set1)
            barChartView.data = data
            barChartView.fitBars = true
        }
        
        barChartView.setNeedsDisplay()
        //        chartView.setNeedsDisplay()
    }
}
