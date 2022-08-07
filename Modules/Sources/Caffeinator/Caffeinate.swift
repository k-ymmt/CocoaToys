//
//  Caffeinate.swift
//  Caffeinator
//
//  Created by Kazuki Yamamoto on 2022/07/31.
//

import Foundation
import Combine
import CocoaToysKit
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

    let fileManager: FileManager
    let logger: Logging

    init(fileManager: FileManager, logger: Logging) {
        self.fileManager = fileManager
        self.logger = logger
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

        logger.info("Start Power Assertion \(id) by \(type.rawValue)")
        return AnyCancellable { [weak self] in
            IOPMAssertionRelease(id)
            self?.logger.info("End Power Assertion \(id) by \(type.rawValue)")
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
}
