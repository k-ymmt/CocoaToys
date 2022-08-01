//
//  CaffeinatorInteractor.swift
//  Caffeinator
//
//  Created by Kazuki Yamamoto on 2022/07/31.
//

import Foundation
import Combine
import CocoaToysKit

final class CaffeinatorInteractor {
    struct Dependency {
        let configManager: ConfigManager
        let service: CaffeinatorServiceType
    }

    private let configManager: ConfigManager
    private let service: CaffeinatorServiceType

    let enabled: RelayPublisher<Bool>
    private var cancellables = Set<AnyCancellable>()

    init(dependency: Dependency) {
        self.configManager = dependency.configManager
        self.service = dependency.service

        let configChanged = configManager.fileChanged(CaffeinatorConfig.self)

        let config = configChanged
            .compactMap(\.success)
            .shareReplay()

        enabled = config
            .map(\.enabled)
            .relayPublisher()

        config
            .map(\.enabled)
            .removeDuplicates()
            .sink { enabled in
                if enabled {
                    Task.detached {
                        do {
                            try await dependency.service.start()
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    dependency.service.stop()
                }
            }.store(in: &cancellables)
    }

    func save(config: CaffeinatorConfig) {
        Task.detached { [weak self] in
            do {
                try await self?.configManager.save(config: config)
                print("Save success!")
            } catch {
                print(error)
            }
        }.store(in: &cancellables)
    }
}
