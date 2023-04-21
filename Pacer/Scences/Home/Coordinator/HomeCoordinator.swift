//
//  HomeCoordinator.swift
//  Pacer
//
//  Created by Nguyen Dang Trong Thai on 4/6/23.
//

import UIKit
import RxSwift

class HomeCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }
    
    var date = Date()
    
    override func start() -> Observable<Void> {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel = viewModel
        
        viewModel.navigateToCalendar.subscribe(onNext: { [weak self] in self?.showCalendar(in: navigationController)
            
        })
            .disposed(by: disposeBag)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
    
    private func showCalendar(in presentingViewController: UIViewController) {
        let viewModel = DetailViewModel(date: date)
        let detailViewController = DetailViewController(viewModel: viewModel, date: date)
        presentingViewController.present(detailViewController, animated: true, completion: nil)
        
        viewModel.selectedDate.subscribe(onNext: { [weak self] data in
            let delayTime = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                detailViewController.dismiss(animated: true, completion: nil)
                self?.date = data
                self?.get(day: Double(data.timestampForDayAndMonth()))
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func get(day: Double) {
        print("Selected day", day)
        guard let homeViewController = (window.rootViewController as? UINavigationController)?.topViewController as? HomeViewController else {
            return
        }
        homeViewController.chartView.viewChart.animate(yAxisDuration: 1.0, easingOption: .easeOutQuart)
        homeViewController.chartDetailView.viewChart.animate(xAxisDuration: 0.01, yAxisDuration: 1.0)
        homeViewController.viewModel.getStep(day: day)
        homeViewController.chartViewModel.getDataChart(day: day)
        homeViewController.chartView.lblDay.text = "".timeStampToDay(timeStamp: day, type: 2)
    }

}
