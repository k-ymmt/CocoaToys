//
//  CaffeinatorService.swift
//  Caffeinator
//
//  Created by Kazuki Yamamoto on 2022/07/31.
//

import Foundation
import CocoaToysKit
import Combine

public protocol CaffeinatorServiceType {
    func start() async throws
    func stop()
}

public final class CaffeinatorService: CaffeinatorServiceType {
    private let manager: ConfigManager
    private var cancellables = Set<AnyCancellable>()

    public init(manager: ConfigManager) {
        self.manager = manager
    }

    func initialize() async throws {
        try await manager.createIfNotExists(defaultConfig: CaffeinatorConfig(enabled: false, noSleepType: .display))
    }

    public func start() async {
        return await withTaskCancellationHandler {
            do {
                try await self.initialize()

                var cancellable: (any Cancellable)?
                self.manager.fileChanged(CaffeinatorConfig.self)
                    .sink { (result: Result<CaffeinatorConfig, ConfigManagerError>) in
                        if let cancellable {
                            cancellable.cancel()
                        }
                        switch result {
                        case .success(let config):
                            if config.enabled {
                                let command = Caffeinate(fileManager: .default)
                                do {
                                    cancellable = try command.executeAssertion(type: .init(config.noSleepType))
                                } catch {
                                    print(error)
                                }
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }.store(in: &self.cancellables)
            } catch {
                print(error)
            }
        } onCancel: {
            cancellables = Set()
            print("Task cancelled")
        }
    }

    public func stop() {
        cancellables = Set()
        print("Stop CaffeinatorService")
    }
}

extension Caffeinate.AssertionType {
    init(_ type: CaffeinatorConfig.NoSleepType) {
        switch type {
        case .display:
            self = .noDisplaySleep
        case .idle:
            self = .noIdleSleep
        }
    }
}
