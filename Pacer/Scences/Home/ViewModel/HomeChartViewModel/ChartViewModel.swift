//
//  ChartViewModel.swift
//  Pacer
//
//  Created by Nguyen Dang Trong Thai on 4/7/23.
//

import Foundation
import RxSwift
import CoreMotion
import Charts
import RealmSwift

class ChartViewModel {
    
    let realm = try! Realm()
    private let disposeBag = DisposeBag()
    
    let entriesValue = PublishSubject<BarChartData>()
    
    func handleOfflineData(_ date: Double, newSteps: Int, hours: Double) {
        if let stepObject = realm.objects(Step.self).filter("date == \(date)").first {
            
            if let stepDetailObject = stepObject.steps.filter("date == \(hours)").first {
                // Cập nhật biến date
                try! realm.write {
                    stepDetailObject.step += newSteps
                    stepObject.step += newSteps
                }
            } else {
                // Tạo mới một đối tượng StepDetail
                let stepDetailObject = StepDetail()
                stepDetailObject.date = hours
                stepDetailObject.step = newSteps
                
                try! realm.write {
                    stepObject.steps.append(stepDetailObject)
                    stepObject.step += newSteps
                }
            }

        } else {
            
            print("trường hợp 2")
            // Tạo mới 1 đối tượng Step
            let stepObject = Step()
            stepObject.date = date
            stepObject.step = newSteps
            
            // Tạo mới 1 đối tượng StepDetail
            let stepDetailObject = StepDetail()
            stepDetailObject.date = hours
            stepDetailObject.step = newSteps
            
            try! realm.write {
                stepObject.steps.append(stepDetailObject)
                realm.add(stepObject)
            }
        }
    }

    func getDataChart(day: Double) {
        let list = realm.objects(Step.self).filter("date = \(day)").toArray(ofType: Step.self)
        print(list)

        var dataEntries: [BarChartDataEntry] = []
        
        for hour in 0...24 {
            
            if let stepArray = list.first?.steps {
                var count: Int = 0
                for i in stepArray {
                    count += 1
                    let yValue = 0.getHour(from: i.date) == hour ? i.step : 0
                    let dataEntry = BarChartDataEntry(x: Double(hour), y: Double(yValue))
                    dataEntries.append(dataEntry)
                }
            }
        }


        let dataset = BarChartDataSet(entries: dataEntries, label: "Steps Chart")
        dataset.colors = [UIColor(rgb: 0x3290DE)]

        let data = BarChartData(dataSet: dataset)
        for dataSet in dataset {
            data.barWidth = 0.15
            dataset.drawValuesEnabled = false
        }
        
        self.entriesValue.onNext(data)
    }
}

extension ChartViewModel {
    
    func addStep(step: Step) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(step)
            }
        } catch let error as NSError {
            print("Lỗi khi thêm đối tượng Step:", error)
        }
    }
    
    func addStepDetail(stepDetail: StepDetail) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(stepDetail)
            }
        } catch let error as NSError {
            print("Lỗi khi thêm đối tượng StepDetail:", error)
        }
    }
    
    func updateStep(step: Step) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(step, update: .modified)
            }
        } catch let error as NSError {
            print("Lỗi khi cập nhật đối tượng Step:", error)
        }
    }
    
    func updateStepDetail(stepDetail: StepDetail) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(stepDetail, update: .modified)
            }
        } catch let error as NSError {
            print("Lỗi khi cập nhật đối tượng StepDetail:", error)
        }
    }
    
    func deleteStep(step: Step) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(step)
            }
        } catch let error as NSError {
            print("Lỗi khi xóa đối tượng Step:", error)
        }
    }
    func deleteStepDetail(stepDetail: StepDetail) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(stepDetail)
            }
        } catch let error as NSError {
            print("Lỗi khi xóa đối tượng StepDetail:", error)
        }
    }
}
