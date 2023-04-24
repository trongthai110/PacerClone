//
//  HomeChartView.swift
//  Pacer
//
//  Created by Nguyen Dang Trong Thai on 4/6/23.
//

import UIKit
import SnapKit
import Charts

class HomeChartView: UIView, ChartViewDelegate {
    
    var background = UIView()
    var viewChart = PieChartView()
    var centerView = UIView()
    var lblDay = UILabel()
    var lblStepsCounting = UILabel()
    var lblStepsGoal = UILabel()
    var lblStepsPercent = UILabel()
    
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
        viewChart.holeRadiusPercent = 0.85
        viewChart.highlightPerTapEnabled = false
        viewChart.rotationEnabled = false
        viewChart.spin(duration: 0.01, fromAngle: viewChart.rotationAngle, toAngle: viewChart.rotationAngle + 135)
        viewChart.animate(yAxisDuration: 1.0, easingOption: .easeOutQuart)
        
        centerView.backgroundColor = .white
        
        lblDay.text = "--/--/--"
        lblDay.textAlignment = .center
        lblDay.textColor = .black
        lblDay.font = .systemFont(ofSize: 20)
        
        lblStepsCounting.text = "0"
        lblStepsCounting.textAlignment = .center
        lblStepsCounting.textColor = UIColor(rgb: 0x3290DE)
        lblStepsCounting.font = .systemFont(ofSize: 75)
        
        lblStepsGoal.text = "Step Goal: 6000"
        lblStepsGoal.textAlignment = .center
        lblStepsGoal.textColor = .black
        lblStepsGoal.font = .systemFont(ofSize: 15)
        
        lblStepsPercent.text = "--% Completed"
        lblStepsPercent.textAlignment = .center
        lblStepsPercent.textColor = .darkGray
        lblStepsPercent.font = .systemFont(ofSize: 15)
        
        self.addSubview(background)
        background.addSubview(viewChart)
        viewChart.addSubview(centerView)
        centerView.addSubview(lblDay)
        centerView.addSubview(lblStepsCounting)
        centerView.addSubview(lblStepsGoal)
        centerView.addSubview(lblStepsPercent)
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
        
        centerView.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(150)
            make.center.equalTo(viewChart)
        }
        
        lblDay.snp.makeConstraints { make in
            make.centerX.equalTo(centerView)
            make.top.equalTo(centerView.snp.top).offset(0)
        }
        
        lblStepsCounting.snp.makeConstraints { make in
            make.center.equalTo(centerView)
        }
        
        lblStepsGoal.snp.makeConstraints { make in
            make.centerX.equalTo(centerView)
            make.top.equalTo(lblStepsCounting.snp.bottom).offset(20)
        }
        
        lblStepsPercent.snp.makeConstraints { make in
            make.centerX.equalTo(centerView)
            make.bottom.equalTo(centerView.snp.bottom).offset(40)
        }
    }
}
