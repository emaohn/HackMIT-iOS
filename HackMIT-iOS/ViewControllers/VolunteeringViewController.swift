//
//  VolunteeringViewController.swift
//  HackMIT-iOS
//
//  Created by Emmie Ohnuki on 9/14/19.
//  Copyright © 2019 Emmie Ohnuki. All rights reserved.
//

import UIKit
import Charts

private class CubicLineSampleFillFormatter: IFillFormatter {
    func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
        return -10
    }
}

class VolunteeringViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lineChartView.backgroundColor = .white
        
        lineChartView.dragEnabled = true
        lineChartView.setScaleEnabled(false)
        lineChartView.pinchZoomEnabled = true
        
        let yAxis = lineChartView.leftAxis
        yAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size:12)!
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .black
        yAxis.labelPosition = .outsideChart
        yAxis.axisLineColor = .black
        
        lineChartView.drawGridBackgroundEnabled = false;
        lineChartView.rightAxis.enabled = false
        lineChartView.legend.enabled = false
        
        lineChartView.animate(xAxisDuration: 2, yAxisDuration: 2)
        
        setChartValues()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UINavigationBar.appearance().tintColor = UIColor.tcOrange
        
    }
    
    func setChartValues() {
        let yVals1 = (1..<8).map { (i) -> ChartDataEntry in
            let mult = 70 + 1
            let val = Double(arc4random_uniform(UInt32(mult)) + 20)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(values: yVals1, label: "Energy")
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 5
        set1.circleRadius = 4
        set1.setCircleColor(.white)
        set1.highlightColor = .blue
        set1.fillColor = .blue
        set1.setColors(.red)
        set1.fillAlpha = 1
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.fillFormatter = CubicLineSampleFillFormatter()
        
        let data = LineChartData(dataSet: set1)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 9)!)
        data.setDrawValues(false)
        
        lineChartView.data = data
    }
    
    func updateChartData() {
        
    }
}
