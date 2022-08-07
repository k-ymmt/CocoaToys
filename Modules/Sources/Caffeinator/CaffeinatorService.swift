//
//  CaffeinatorService.swift
//  Caffeinator
//
//  Created by Kazuki Yamamoto on 2022/07/31.
//

import Foundation
import CocoaToysKit
import Combine

public final class CaffeinatorService: CaffeinatorServiceType {
    private actor Properties {
        var isStarted: Bool

        init(isStarted: Bool) {
            self.isStarted = isStarted
        }

        func setIsStarted(_ started: Bool) {
            self.isStarted = started
        }
    }

    private let manager: ConfigManager
    private var cancellables = Set<AnyCancellable>()
    private var fileChangedCancellable: (any Cancellable)?
    private let properties: Properties

    public init(manager: ConfigManager) {
        self.manager = manager
        self.properties = Properties(isStarted: false)
    }

    public func start() async {
        return await withTaskCancellationHandler {
            if await properties.isStarted {
                print("CaffeinatorService already started.")
                return
            }

            await properties.setIsStarted(true)
            do {
                try await initialize()

                self.sinkFileChanged()
                    .store(in: &self.cancellables)
            } catch {
                print(error)
            }
        } onCancel: {
            cancellables = Set()
            print("Task cancelled")
        }
    }

    public func stop() async {
        if await !properties.isStarted {
            return
        }
        await properties.setIsStarted(false)
        cancellables = Set()
        print("Stop CaffeinatorService")
    }
}

private extension CaffeinatorService {
    func initialize() async throws {
        try await manager.createIfNotExists(defaultConfig: CaffeinatorConfig(enabled: false, noSleepType: .display))
    }

    func sinkFileChanged() -> some Cancellable {
        manager.fileChanged(CaffeinatorConfig.self)
            .sink { [weak self] (result: Result<CaffeinatorConfig, ConfigManagerError>) in
                guard let self else {
                    return
                }
                let cancellable = self.fileChangedCancellable
                if let cancellable {
                    cancellable.cancel()
                }
                switch result {
                case .success(let config):
                    if config.enabled {
                        let command = Caffeinate(fileManager: .default)
                        do {
                            self.fileChangedCancellable = try command.executeAssertion(type: .init(config.noSleepType))
                        } catch {
                            print(error)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
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
