//
//  AnyRecordModel.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - AnyRecordModel
protocol AnyRecordModel {
    /// Properties
    var timestampRecord: Double { get }
    var valueRecord: Float { get }
    var sensorModel: AnySensorModel { get }
}

class ReadingRealm: Object {
    @objc dynamic var sensorModel: SensorRealm?
    @objc dynamic var timestampRecord: NSDate = NSDate()
    @objc dynamic var valueRecord: Float = 0.0
}
