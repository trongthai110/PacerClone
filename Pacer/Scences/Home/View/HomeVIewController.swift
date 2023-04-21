//
//  HomeViewController.swift
//  Pacer
//
//  Created by Nguyen Dang Trong Thai on 4/5/23.
//

import UIKit
import CoreMotion
import SnapKit
import RxSwift
import Charts
import RxCocoa
import Darwin

class HomeViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel: HomeViewModel
    var chartViewModel = ChartViewModel()
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    var scrollView = UIScrollView(frame: UIScreen.main.bounds)
    var contentView = UIView()
    
    var homeView = HomeDetailView()
    var chartView = HomeChartView()
    var chartDetailView = HomeChartDetailView()
    
    let screensize: CGRect = UIScreen.main.bounds
    let hours: Int = Int(Date().timeIntervalSince1970.hoursInDay())
    
    var steps = Int()
    var totalSteps = Int()
    var distance = Double()
    var time = Double()
    var calories = Int()
    var stepsPercent = Double()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeSubscribers()
    }
}

extension HomeViewController {
    
    func initializeUI() {
        viewModel.title.bind(to: navigationItem.rx.title).disposed(by: disposeBag)
        
        scrollView.backgroundColor = .white
        contentView.backgroundColor = .white
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(homeView)
        contentView.addSubview(chartView)
        contentView.addSubview(chartDetailView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.snp.width)
        }

        homeView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.width.equalToSuperview()
            make.top.equalTo(contentView.snp.top).offset(0)
            make.left.equalTo(contentView.snp.left).offset(0)
            make.right.equalTo(contentView.snp.right).offset(0)
        }
        
        chartView.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.width.equalToSuperview()
            make.top.equalTo(homeView.snp.bottom).offset(0)
            make.left.equalTo(contentView.snp.left).offset(0)
            make.right.equalTo(contentView.snp.right).offset(0)
        }
        
        chartDetailView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.width.equalToSuperview()
            make.top.equalTo(chartView.snp.bottom).offset(0)
            make.left.equalTo(contentView.snp.left).offset(0)
            make.right.equalTo(contentView.snp.right).offset(0)
            make.bottom.equalTo(contentView.snp.bottom).offset(-100)
        }
    }
    
    func initializeSubscribers() {
        
        
        // MARK: - ================================= PushView =================================
        chartView.centerView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.rx.event.bind(onNext: { [weak self] _ in
                self?.viewModel.chartTapped() })
            .disposed(by: disposeBag)
        
        // MARK: - ================================= HomeViewModel =================================
        viewModel.totalStepsValue
                    .subscribe(onNext: { [weak self] data in
                        self?.totalSteps = data
                        self?.displayLabel(stepsValue: 0)
                    })
                    .disposed(by: disposeBag)
        
        viewModel.stepsValue
                    .subscribe(onNext: { [weak self] data in
                        self?.displayLabel(stepsValue: data)
                        self?.chartViewModel.handleOfflineData(steps: data, day: 0.getTimeStamp(), hours: self!.hours)
                    })
                    .disposed(by: disposeBag)
        
        viewModel.entriesValue
                    .subscribe(onNext: { [weak self] data in
                        self?.chartView.viewChart.data = data
                    })
                    .disposed(by: disposeBag)
        
        // MARK: - ================================= ChartViewModel =================================
        
        chartViewModel.entriesValue
                    .subscribe(onNext: { [weak self] data in
                        self?.chartDetailView.viewChart.data = data
                    })
                    .disposed(by: disposeBag)
        
        // MARK: - ================================= Call Func =================================
        
        viewModel.getStep(day: 0.getTimeStamp())
        chartViewModel.getDataChart(day: 0.getTimeStamp())
    }
    
    func displayLabel(stepsValue: Int) {
        steps = stepsValue + totalSteps
        distance = (1.8 * 0.414) * Double(steps)
        time = distance/1.34
        calories = Int(time * 3.5 * 3.5 * 70 / (200 * 60))
        if steps > 6000 {
            stepsPercent = 100
        } else {
            stepsPercent = (Double(steps) / 6000) * 100
        }
        
        homeView.lblValueCalories.text = String(calories)
        homeView.lblValueActiveTime.text = time.asString(style: .abbreviated)
        homeView.lblValueDistance.text = String(round(distance / 1000))
        chartView.lblDay.text = "".timeStampToDay(timeStamp: 0.getTimeStamp(), type: 2)
        chartView.lblStepsCounting.text = String(steps)
        chartView.lblStepsPercent.text = String(Int(stepsPercent)) + "% Completed"
    }
}
