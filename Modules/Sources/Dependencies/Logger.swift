//
//  Logger.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/08/07.
//

import Foundation
import CocoaToysKit
import os

public final class Logger: Logging {
    private let logger: os.Logger
    private let logLevel: Loggings.LogLevel

    public init(category: String, logLevel: Loggings.LogLevel) {
        self.logger = .init(subsystem: "app.kymmt.CocoaToys", category: category)
        self.logLevel = logLevel
    }


    public func log(_ logLevel: Loggings.LogLevel, message: @escaping @autoclosure () -> String, file: String, function: String, line: Int) {
        guard self.logLevel <= logLevel else {
            return
        }
        switch logLevel {
        case .debug:
            logger.debug("\(message())")
        case .info:
            logger.info("\(message())")
        case .warn:
            logger.warning("\(message())")
        case .error:
            logger.error("\(message())")
        }
    }
}
