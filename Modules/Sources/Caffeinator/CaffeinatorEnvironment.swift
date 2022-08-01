//
//  CaffeinatorEnvironment.swift
//  Caffeinator
//
//  Created by Kazuki Yamamoto on 2022/07/31.
//

import Foundation
import Combine
import CocoaToysKit

public protocol CaffeinatorEnvironment: Environment {
    var caffeinatorService: CaffeinatorServiceType { get }
}

#if DEBUG
public final class MockEnvironment: CaffeinatorEnvironment {
    private let mock = CocoaToysKit.MockEnvironment()
    public init() {
    }

    public var configManager: ConfigManager {
        return mock.configManager
    }

    public var caffeinatorService: CaffeinatorServiceType {
        final class Dummy: CaffeinatorServiceType {
            func start() async throws {
            }
            func stop() {
            }
        }

        return Dummy()
    }
}
#endif
