//
//  DetailView.swift
//  Pacer
//
//  Created by Nguyen Dang Trong Thai on 4/11/23.
//

import UIKit
import SnapKit

class DetailView: UIView {

    var background = UIView()
    var datePicker = UIDatePicker()
    var lblSteps = UILabel()
    var lblDistance = UILabel()
    var lblAvg = UILabel()
    var btnGoToday = UIButton(type: .system)
    
    let screensize: CGRect = UIScreen.main.bounds
    
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
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        lblSteps.textColor = UIColor(rgb: 0x3290DE)
        lblDistance.textColor = UIColor(rgb: 0x3290DE)
        lblAvg.textColor = UIColor.black
        btnGoToday.setTitle("Go Today", for: .normal)
        btnGoToday.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
        lblSteps.font = .systemFont(ofSize: 25)
        lblDistance.font = .systemFont(ofSize: 25)
        lblAvg.font = .systemFont(ofSize: 20)
//        lblAvg.layer.masksToBounds = true
//        lblAvg.layer.cornerRadius = 10
//        lblAvg.layer.borderWidth = 1
//        lblAvg.layer.borderColor = UIColor.gray.cgColor

        self.addSubview(background)
        background.addSubview(datePicker)
        background.addSubview(lblSteps)
        background.addSubview(lblDistance)
        background.addSubview(lblAvg)
        background.addSubview(btnGoToday)
    }
    
    override func layoutSubviews() {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        datePicker.snp.makeConstraints { make in
            make.center.equalTo(background)
            make.width.equalTo(screensize.width - 36)
        }
        lblSteps.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(background.snp.top).offset(50)
            make.bottom.greaterThanOrEqualTo(datePicker.snp.top).offset(-20)
            make.left.equalTo(background.snp.left).offset(20)
            make.width.lessThanOrEqualTo(screensize.width/1.5)
        }
        lblDistance.snp.makeConstraints { make in
            make.centerY.equalTo(lblSteps)
            make.left.equalTo(lblSteps.snp.right).offset(30)
            make.right.greaterThanOrEqualTo(background.snp.right).offset(-20)
        }
        btnGoToday.snp.makeConstraints { make in
            make.centerX.equalTo(background)
            make.top.greaterThanOrEqualTo(datePicker.snp.bottom).offset(0)
        }
        lblAvg.snp.makeConstraints { make in
            make.centerX.equalTo(background)
            make.top.greaterThanOrEqualTo(btnGoToday.snp.bottom).offset(0)
            make.bottom.lessThanOrEqualTo(background.snp.bottom).offset(-30)
        }
    }
}
