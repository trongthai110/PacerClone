//
//  DetailViewModel.swift
//  Pacer
//
//  Created by Nguyen Dang Trong Thai on 4/11/23.
//

import RxSwift
import RealmSwift

class DetailViewModel {
    
    private let disposeBag = DisposeBag()
    let selectedDate = PublishSubject<Date>()
    
    let date: Date
        
    init(date: Date) {
        self.date = date
    }
        
    func didSelectDate(_ date: Date) {
        selectedDate.onNext(date)
    }
}

extension DetailViewModel {
    func monthlySteps(for days: [Int]) -> Int {
        let realm = try! Realm()
        var totalSteps = 0
        
        for day in days {
            guard let stepData = realm.objects(Step.self).filter("date == %@", day).first else {
                continue // không tìm thấy đối tượng Health cho ngày này thì bỏ qua
            }
            totalSteps += stepData.step
        }
        return totalSteps
    }
    
    func monthlyStepsAvg(for days: [Int]) -> Int {
        let realm = try! Realm()
        var totalDate = 0
        
        for day in days {
            guard let stepData = realm.objects(Step.self).filter("date == %@", day).first else {
                continue // không tìm thấy đối tượng Health cho ngày này thì bỏ qua
            }
            totalDate += 1
        }
        
        if totalDate == 0 {
            totalDate = 1
        }
        return totalDate
    }
    
    func getAllTimestamp() -> [Double] {
        let realm = try! Realm()
        let healthObjects = realm.objects(Step.self)
        var days = [Double]()
        for healthObject in healthObjects {
            days.append(healthObject.date)
        }
        return days
    }
}
