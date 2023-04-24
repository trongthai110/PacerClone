//
//  HomeViewModel.swift
//  Pacer
//
//  Created by Nguyen Dang Trong Thai on 4/6/23.
//

import Foundation
import RxSwift
import CoreMotion
import Charts
import RealmSwift
import RxCocoa

class HomeViewModel {
    
    let navigateToCalendar = PublishRelay<Void>()
    
    let realm = try! Realm()
    var chartViewModel = ChartViewModel()
    let stepsValue = PublishSubject<Int>()
    let totalStepsValue = PublishSubject<Int>()
    let entriesValue = PublishSubject<PieChartData>()
    let hours: Int = Int(Date().timeIntervalSince1970.hoursInDay())
    private let stepsCounting = CMPedometer()
    
    let stepGoal: Double = 6000
    var space: Double = 0
    var stepsPercent: Double = 0
    
    let title = BehaviorSubject<String>(value: "Home")
    
    func chartTapped() {
        navigateToCalendar.accept(())
        print("chart tapped")
    }
    
    func getStep(day: Double) {
        
        // MARK: - ================================= Home Chart View Data =================================
        
        let steps = Double(dailySteps(day)!)
        
        if steps > stepGoal {
            stepsPercent = 75
        } else {
            stepsPercent = (((steps/stepGoal) * 100) / 100) * 75
        }
        space = 75 - stepsPercent
        
        let entries = [PieChartDataEntry(value: 25), PieChartDataEntry(value: stepsPercent), PieChartDataEntry(value: space)]
        
        let dataset = PieChartDataSet(entries: entries)
        dataset.colors = [UIColor.white,UIColor(rgb: 0x3290DE), UIColor(rgb: 0xE4E4E4)]
        let data = PieChartData(dataSet: dataset)
        for dataSet in dataset {
            dataset.drawValuesEnabled = false
        }
        
        self.entriesValue.onNext(data)

        // MARK: - ================================= Total Step Data =================================
        totalStepsValue.onNext(dailySteps(day)!)
        
        // MARK: - ================================= Step Count Data =================================
        
                
        if CMPedometer.isStepCountingAvailable() {
            stepsCounting.startUpdates(from: Date()) { pedometerData, error in
                guard let pedometerData = pedometerData, error == nil else { return }
                DispatchQueue.main.async {
                    if day == 0.getTimeStamp() {
                        self.stepsValue.onNext(pedometerData.numberOfSteps.intValue)
                    } else {
                        self.chartViewModel.handleOfflineData(0.getTimeStamp(), newSteps: pedometerData.numberOfSteps.intValue, hours: Date().hourTimestamp())
                        print("Day in the past")
                        print("New step for today: ", pedometerData.numberOfSteps.intValue)
                    }
                }
            }
        }
    }
}

extension HomeViewModel {
    func dailySteps(_ date: Double) -> Int? {
        if let stepObject = realm.objects(Step.self).filter("date == \(date)").first {
            return stepObject.step
        } else {
            return 0
        }
    }
}
