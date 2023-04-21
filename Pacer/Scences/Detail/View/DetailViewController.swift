//
//  DetailViewController.swift
//  Pacer
//
//  Created by Nguyen Dang Trong Thai on 4/11/23.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel: DetailViewModel
    private let date: Date
    let screensize: CGRect = UIScreen.main.bounds
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    init(viewModel: DetailViewModel, date: Date) {
        self.viewModel = viewModel
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }

    var contentView = UIView(frame: UIScreen.main.bounds)
    var detailView = DetailView()
    let tapView = UIView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUI()
        initializeSubscribers()
        displayLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Calendar.current.isDate(detailView.datePicker.date, inSameDayAs: Date()) {
            detailView.btnGoToday.isHidden = true
        } else {
            detailView.btnGoToday.isHidden = false
        }
    }
}

extension DetailViewController {
    func initializeUI() {
        
        contentView.backgroundColor = .white
        tapView.backgroundColor = .clear
        view.addSubview(contentView)
        view.addSubview(tapView)
        contentView.addSubview(detailView)
        
        tapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalTo(contentView.snp.top)
        }
        
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(screensize.height/1.5)
        }
        
        detailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let oldestDate = viewModel.getAllTimestamp().oldestDate()
        let minimumDate = Calendar.current.date(byAdding: .month, value: 0, to: oldestDate!)!
        let maximumDate = Calendar.current.date(byAdding: .month, value: 0, to: Date())!

        detailView.datePicker.minimumDate = minimumDate
        detailView.datePicker.maximumDate = maximumDate
    }
    
    func initializeSubscribers() {
        
        // MARK: - ================================= DismissView =================================
        tapView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.rx.event.bind(onNext: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
            
        })
            .disposed(by: disposeBag)
        
        // MARK: - ================================= Btn go today =================================
        detailView.btnGoToday.rx.tap.bind(onNext: { [weak self] _ in
            let today = Date()
            self?.detailView.datePicker.setDate(today, animated: true)
            self?.viewModel.didSelectDate(today)
        })
            .disposed(by: disposeBag)
        
        detailView.datePicker.setDate(date, animated: true)
        
        // MARK: - ================================= Bind datePicker to viewModel =================================
        detailView.datePicker.rx.date
            .subscribe(onNext: { [weak self] date in
                self?.viewModel.didSelectDate(date)
            })
            .disposed(by: disposeBag)
    }
    
    func displayLabel() {
        let month = detailView.datePicker.calendar.component(.month, from: detailView.datePicker.date)
        let days = 0.getTimestampsOfMonth(month: month)
        let monthlySteps: Int = viewModel.monthlySteps(for: days)
        let monthlyDistance = ((1.8 * 0.414) * Double(monthlySteps))
        let monthlyAvg: Int = viewModel.monthlyStepsAvg(for: days)
        
        detailView.lblSteps.text = monthlySteps.thousandsSeparator() + " steps"
        detailView.lblDistance.text = String(round(monthlyDistance / 1000)) + " km"
        detailView.lblAvg.text = "Avg. " + (monthlySteps/monthlyAvg).thousandsSeparator()
    }
}
