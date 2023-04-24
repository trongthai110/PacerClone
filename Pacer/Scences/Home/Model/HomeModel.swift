//
//  Step.swift
//  Pacer
//
//  Created by Nguyen Dang Trong Thai on 4/6/23.
//

import Foundation
import RealmSwift

class Step: Object {
    @Persisted(primaryKey: true) var id: Int = UUID().hashValue
    @Persisted var date: Double
    @Persisted var step: Int
    @Persisted var steps = List<StepDetail>()
}

class StepDetail: Object {
    @Persisted(primaryKey: true) var id: Int = UUID().hashValue
    @Persisted var date: Double
    @Persisted var step: Int
}
