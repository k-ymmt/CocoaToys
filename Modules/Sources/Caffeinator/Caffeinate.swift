//
//  Caffeinate.swift
//  Caffeinator
//
//  Created by Kazuki Yamamoto on 2022/07/31.
//

import Foundation
import Combine
import IOKit.pwr_mgt

final class Caffeinate {
    struct Error: Swift.Error {
        let message: String
    }

    enum AssertionType: String {
        case noDisplaySleep
        case noIdleSleep
        case preventSystemSleep
        case preventUserIdleDisplaySleep
        case preventUserIdleSystemSleep

        var rawValue: String {
            switch self {
            case .noDisplaySleep:
                return kIOPMAssertionTypeNoDisplaySleep
            case .noIdleSleep:
                return kIOPMAssertionTypeNoIdleSleep
            case .preventSystemSleep:
                return kIOPMAssertionTypePreventSystemSleep
            case .preventUserIdleDisplaySleep:
                return kIOPMAssertionTypePreventUserIdleDisplaySleep
            case .preventUserIdleSystemSleep:
                return kIOPMAssertionTypePreventUserIdleSystemSleep
            }
        }
    }

    let executableURL = URL(fileURLWithPath: "/usr/bin/caffeinate")
    let fileManager: FileManager
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    func executeAssertion(type: AssertionType) throws -> some Cancellable {
        var id = IOPMAssertionID(0)
        let result = IOPMAssertionCreateWithName(
            type.rawValue as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            "Caffeinator" as CFString,
            &id
        )
        guard result == kIOReturnSuccess else {
            throw Error(message: "Create failed")
        }

        print("Start Power Assertion \(id) by \(type.rawValue)")
        return AnyCancellable {
            IOPMAssertionRelease(id)
            print("End Power Assertion \(id) by \(type.rawValue)")
        }
    }
    func executeAssertionUserIsActive() throws -> some Cancellable {
        var id = IOPMAssertionID(0)
        let result = IOPMAssertionCreateWithDescription(
            AssertionType.preventUserIdleDisplaySleep.rawValue as CFString,
            "Caffeinator" as CFString,
            "Running by Caffeinator" as CFString,
            nil,
            nil,
            CFTimeInterval(300),
            kIOPMAssertionTimeoutActionRelease as CFString,
            &id
        )

        guard result == kIOReturnSuccess else {
            throw Error(message: "Create failed")
        }

        return AnyCancellable {
            IOPMAssertionRelease(id)
        }
    }
    func preventSystemFromIdleSleeping(pid: String? = nil) async throws {
        try await runCaffeinate(args: ["-i"] + (pid.map { ["-w", $0] } ?? []))
    }

    func executeAssertion() {

    }

    private func runCaffeinate(args: [String]) async throws {
//        guard fileManager.fileExists(atPath: executableURL.path) else {
//            throw Self.Error(message: "caffeinate command not found")
//        }
//        let process = Process()
//        try await withTaskCancellationHandler {
//            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Swift.Error>) in
//                process.executableURL = executableURL
//                process.arguments = args
//
//                let stderr = Pipe()
//                process.standardError = stderr
//
//                print("Running caffeinate")
//                do {
//                    try process.run()
//                    process.waitUntilExit()
//                    print("Finished caffeinate")
//                    let handle = stderr.fileHandleForReading
//                    let data = handle.readDataToEndOfFile()
//                    print(String(data: data, encoding: .utf8) ?? "nil")
//                    continuation.resume()
//                } catch {
//                    continuation.resume(throwing: error)
//                }
//            }
//        } onCancel: {
//            process.terminate()
//            print("onCancel")
//        }
    }
}

extension Process: @unchecked Sendable {
}
