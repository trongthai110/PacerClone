//
//  HomeChartDetailView.swift
//  Pacer
//
//  Created by Nguyen Dang Trong Thai on 4/6/23.
//

import UIKit
import SnapKit
import Charts

class HomeChartDetailView: UIView, ChartViewDelegate {
    
    var background = UIView()
    var viewChart = BarChartView()
    var label = ["", "", "", "", "", "", "06:00", "", "", "", "", "", "12:00", "", "", "", "", "", "18:00", "", "", "", "", "", "00:00" ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    func setupSubviews() {
        background.backgroundColor = .white
        viewChart.delegate = self
        viewChart.backgroundColor = .white
        viewChart.legend.enabled = false
        viewChart.scaleXEnabled = false
        viewChart.scaleYEnabled = false
        viewChart.dragEnabled = false
        // Thiết lập trục X cho biểu đồ
        let xAxis = viewChart.xAxis
        xAxis.labelPosition = .bottomInside
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        xAxis.labelTextColor = .black
        xAxis.labelCount = 25
        xAxis.drawLabelsEnabled = true
        xAxis.valueFormatter = IndexAxisValueFormatter(values: label)
        // Thiết lập trục Y cho biểu đồ
        let leftAxis = viewChart.leftAxis
        leftAxis.drawAxisLineEnabled = false
        leftAxis.labelCount = 3
        viewChart.animate(xAxisDuration: 0.01, yAxisDuration: 1.0)
        
        let rightAxis = viewChart.rightAxis
        rightAxis.enabled = false
        rightAxis.drawLabelsEnabled = false
        
        self.addSubview(background)
        background.addSubview(viewChart)
    }
    
    override func layoutSubviews() {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        viewChart.snp.makeConstraints { make in
            make.width.equalTo(background)
            make.height.equalTo(background)
            make.center.equalTo(background)
        }
    }
}
