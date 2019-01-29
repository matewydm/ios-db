//
//  AnyDatabaseService.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation

// MARK: - DatabaseServiceChange
enum DatabaseServiceChange {
    case generatingRecordsFinished(Int) // Int - count of records
    case experimentFinished(Int) // Int - count of records
    case deleteAllFinished(Int) // Int - count of records
    case logLine(String) // String - a new line for log screen
}

typealias DatabaseServiceHandler = (DatabaseServiceChange) -> ()

// MARK: - AnyDatabaseService
protocol AnyDatabaseService: class {
    /// Properties
    var startTime: Date? { get set }
    /// Generate Methods
    func generate(recordsNumber: Int)
    /// Experiments Methods
    func makeExperiment(recordsNumber: Int)
    /// Delete Methods
    func deleteAllRecords()
    /// Time Measuring
    func startMeasureTime()
    func finishMeasureTime() -> Double
    /// Handler Methods
    func addHandler(_ completion: @escaping DatabaseServiceHandler) -> Int
    func removeHandler(_ handlerId: Int)
}

// MARK: - Time Measuring Implementation
extension AnyDatabaseService {
    func startMeasureTime() {
        startTime = Date()
    }
    func finishMeasureTime() -> Double {
        guard let startTime = startTime else { return 0.0 }
        return Date().timeIntervalSince(startTime)
    }
}
