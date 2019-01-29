//
//  SQLiteService.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation

protocol AnySQLiteService: AnyDatabaseService {
    func getAllSensors() -> [AnySensorModel]
    func getAllRecords() -> [AnyRecordModel]
    // TODO: - Add extra methods if needed
}

class SQLiteService {
    // MARK: - Static Properties
    static let shared: SQLiteService = SQLiteService()
    // MARK: - Properties
    var startTime: Date?
    // MARK: - Private Properties
    fileprivate var observingHandlers: [Int: DatabaseServiceHandler] = [:]
    // MARK: - Init
    private init() {
        // TODO: Configure Service If You want
    }
    deinit {
        observingHandlers.removeAll()
    }
    // MARK: - Private Help/Cofigure/Init etc. Methods
    // TODO: - Work There...
}

extension SQLiteService: AnySQLiteService {
    // MARK: - AnySQLiteService -
    func getAllSensors() -> [AnySensorModel] {
        return [] // TODO: - Implement
    }
    func getAllRecords() -> [AnyRecordModel] {
        return [] // TODO: - Implement
    }
    // MARK: - AnyDatabaseService -
    // MARK: - Generate Methods
    func generate(recordsNumber: Int) {
        notifyObservers(change: .logLine("SQLite"))
        notifyObservers(change: .logLine(#function))
        // TODO: - Implement
    }
    // MARK: - Experiments Methods
    func makeExperiment(recordsNumber: Int) {
        notifyObservers(change: .logLine("SQLite"))
        notifyObservers(change: .logLine(#function))
        // TODO: - Implement
    }
    // MARK: - Delete Methods
    func deleteAllRecords() {
        notifyObservers(change: .logLine("SQLite"))
        notifyObservers(change: .logLine(#function))
        // TODO: - Implement
    }
    // MARK: - Handler Methods
    func addHandler(_ completion: @escaping DatabaseServiceHandler) -> Int {
        var maxId = observingHandlers.keys.max() ?? 0
        maxId += 1
        observingHandlers[maxId] = completion
        return maxId
    }
    func removeHandler(_ handlerId: Int) {
        observingHandlers.removeValue(forKey: handlerId)
    }
    private func notifyObservers(change: DatabaseServiceChange) {
        observingHandlers.forEach { (handler) in
            handler.value(change)
        }
    }
}
