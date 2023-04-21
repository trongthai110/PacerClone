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
    
    var distance = Double()
    var time = Double()
    var calories = Double()
    
    private let activityTracking = CMMotionActivityManager()
    private let stepsCounting = CMPedometer()
    
    func handleOfflineData(steps: Int, day: Double, hours: Int) {
        let realm = try! Realm()
        if let health = realm.objects(Health.self).filter("day == \(day)").first {
            if let hourlyHealth = health.hours.first(where: { $0.hour == hours }) {
                updateData(currentDay: day, newStep: steps, newHours: hours)
            } else {
                //Tạo mới một đối tượng HourlyHealth và thêm đối tượng này vào mảng hours của Health
                let hourlyHealth = HourlyHealth(hour: hours, steps: steps)
                try! realm.write {
                    health.hours.append(hourlyHealth)
                }
            }
        } else {
            let hourlyHealths = [
                HourlyHealth(hour: hours, steps: steps)
            ]
            saveData(day: day, hourlyHealths: hourlyHealths)
        }
    }

    func getDataChart(day: Double) {
        
        let list = realm.objects(Health.self).filter("day = %@ ", day).toArray(ofType: Health.self)
        print(list)

        var dataEntries: [BarChartDataEntry] = []

        for i in 1..<25 {
            let hour = list.last?.hours.first(where: {$0.hour == i})
            let steps = hour?.steps ?? 0
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(steps))
            dataEntries.append(dataEntry)
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
    
    func saveData(day: Double, hourlyHealths: [HourlyHealth]) {
        let data = Health(day: day)
        for hourlyHealth in hourlyHealths {
            data.hours.append(hourlyHealth)
        }
        try! realm.write {
            realm.add(data)
        }
    }

    func deleteData(day: Double) {
        let data = realm.objects(Health.self).filter("day = %@ ", day)
            try! realm.write {
                realm.delete(data)
            }
    }
    
    func updateData(currentDay: Double, newStep: Int, newHours: Int) {
        let data = realm.objects(Health.self).filter("day = %@ ", currentDay).toArray(ofType: Health.self).first
        if let data = data {
            if let hourData = data.hours.first(where: { $0.hour == newHours }) {
                try! realm.write {
                    hourData.steps = hourData.steps + newStep
                }
            }
        }
    }
}
