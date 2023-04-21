//
//  Step.swift
//  Pacer
//
//  Created by Nguyen Dang Trong Thai on 4/6/23.
//

import Foundation
import RealmSwift

class Health: Object {
    @objc dynamic var day: Double = 0
    var hours = List<HourlyHealth>()
    convenience init( day: Double) {
        self.init()
        self.day = day
    }
}

class HourlyHealth: Object {
    @objc dynamic var hour: Int = 0
    @objc dynamic var steps: Int = 0
    
    convenience init(hour: Int, steps: Int) {
        self.init()
        self.hour = hour
        self.steps = steps
    }
}
