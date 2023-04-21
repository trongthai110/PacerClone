//
//  HomeDetailCell.swift
//  Pacer
//
//  Created by Nguyen Dang Trong Thai on 4/5/23.
//

import UIKit
import SnapKit

class HomeDetailView: UIView {

    var background = UIView()
    var lblTitleCalories = UILabel()
    var lblTitleActiveTime = UILabel()
    var lblTitleDistance = UILabel()
    var lblValueCalories = UILabel()
    var lblValueActiveTime = UILabel()
    var lblValueDistance = UILabel()
    
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
        lblTitleCalories.textColor = .black
        lblTitleActiveTime.textColor = .black
        lblTitleDistance.textColor = .black
        lblValueCalories.textColor = UIColor(rgb: 0xF45D2B)
        lblValueActiveTime.textColor = UIColor(rgb: 0x7AA400)
        lblValueDistance.textColor = UIColor(rgb: 0x3290DE)
        
        lblValueCalories.font = .systemFont(ofSize: 40)
        lblValueActiveTime.font = .systemFont(ofSize: 40)
        lblValueDistance.font = .systemFont(ofSize: 40)
        
        lblTitleCalories.text = "Calories"
        lblTitleActiveTime.text = "Active Time"
        lblTitleDistance.text = "Km"
        lblValueCalories.text = "--"
        lblValueActiveTime.text = "--"
        lblValueDistance.text = "--"
        
        self.addSubview(background)
        background.addSubview(lblTitleCalories)
        background.addSubview(lblTitleActiveTime)
        background.addSubview(lblTitleDistance)
        background.addSubview(lblValueCalories)
        background.addSubview(lblValueActiveTime)
        background.addSubview(lblValueDistance)
        
    }
    
    override func layoutSubviews() {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        lblTitleCalories.snp.makeConstraints { make in
            make.top.equalTo(background.snp.top).offset(50)
            make.bottom.equalTo(lblValueCalories.snp.top).offset(80)
            make.centerX.equalTo(lblValueCalories)
        }
        lblTitleActiveTime.snp.makeConstraints { make in
            make.centerY.equalTo(lblTitleCalories)
            make.centerX.equalTo(background)
        }
        lblTitleDistance.snp.makeConstraints { make in
            make.centerY.equalTo(lblTitleCalories)
            make.centerX.equalTo(lblValueDistance)
        }
        lblValueCalories.snp.makeConstraints { make in
            make.bottom.greaterThanOrEqualTo(background.snp.bottom).offset(0)
            make.left.equalTo(background.snp.left).offset(35)
        }
        lblValueActiveTime.snp.makeConstraints { make in
            make.centerX.equalTo(background)
            make.centerY.equalTo(lblValueCalories)
            make.left.greaterThanOrEqualTo(lblValueCalories.snp.right).offset(10)
            make.right.greaterThanOrEqualTo(lblValueActiveTime.snp.left).offset(10)
        }
        lblValueDistance.snp.makeConstraints { make in
            make.centerY.equalTo(lblValueCalories)
            make.right.equalTo(background.snp.right).offset(-35)
        }
    }
}

