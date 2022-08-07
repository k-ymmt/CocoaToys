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

    @Published var enabled: Bool = false
    @Published var noSleepType: CaffeinatorConfig.NoSleepType = .display

    private var cancellables = Set<AnyCancellable>()

    init(dependency: Dependency) {
        self.configManager = dependency.configManager
        self.service = dependency.service

        let configChanged = configManager.fileChanged(CaffeinatorConfig.self)

        let config = configChanged
            .compactMap(\.success)

        config
            .map(\.enabled)
            .removeDuplicates()
            .assign(to: &$enabled)
        config
            .map(\.noSleepType)
            .removeDuplicates()
            .assign(to: &$noSleepType)

        $enabled
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] isEnabled in
                guard let self else {
                    return
                }
                print(isEnabled)
                Task.detached {
                    do {
                        try await self.configManager.update { (config: inout CaffeinatorConfig) in
                            config.enabled = isEnabled
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            .store(in: &cancellables)

        $noSleepType
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] noSleepType in
                print(noSleepType)
                guard let self else {
                    return
                }

                Task.detached {
                    do {
                        try await self.configManager.update(action: { (config: inout CaffeinatorConfig) in
                            config.noSleepType = noSleepType
                        })
                    } catch {
                        print(error)
                    }
                }
            }
            .store(in: &cancellables)
    }
}
