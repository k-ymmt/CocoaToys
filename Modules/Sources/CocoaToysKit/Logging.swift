//
//  Logging.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/08/07.
//

import Foundation

public enum Loggings {
    public enum LogLevel {
        case debug
        case info
        case warn
        case error
    }
}

public protocol Logging {
    func log(_ logLevel: Loggings.LogLevel, message: @escaping @autoclosure () -> String, file: String, function: String, line: Int)
}

public extension Logging {
    func debug(_ message: @escaping @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.debug, message: message(), file: file, function: function, line: line)
    }
    func info(_ message: @escaping @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.info, message: message(), file: file, function: function, line: line)
    }
    func warn(_ message: @escaping @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.warn, message: message(), file: file, function: function, line: line)
    }
    func error(_ message: @escaping @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.error, message: message(), file: file, function: function, line: line)
    }

    func error(_ error: Error, file: String = #file, function: String = #function, line: Int = #line) {
        log(.error, message: "\(error)", file: file, function: function, line: line)
    }
}
