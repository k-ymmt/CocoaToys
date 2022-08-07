//
//  CaffeinatorStatusMenuItemInteractor.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/08/06.
//

import Foundation
import CocoaToysKit
import Combine

final class CaffeinatorStatusMenuItemInteractor {
    @Published var isEnabled: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let configManager: ConfigManager
    private let logger: Logging

    init(environment: CaffeinatorStatusMenuItemEnvironment) {
        self.configManager = environment.configManager
        self.logger = environment.caffeinatorLogger
        let config = environment
            .configManager
            .fileChanged(CaffeinatorConfig.self)
            .compactMap(\.success)
            .map(\.enabled)
            .removeDuplicates()
            .shareReplay()

        config.assign(to: &$isEnabled)

        config
            .sink { isEnabled in
                Task.detached {
                    if isEnabled {
                        try await environment.caffeinatorService
                            .start()
                    } else {
                        await environment.caffeinatorService
                            .stop()
                    }
                }
            }
            .store(in: &cancellables)
    }

    func saveIsEnabled(_ isEnabled: Bool) {
        Task.detached { [weak self] in
            guard let self else {
                return
            }
            do {
                try await self.configManager.update { (config: inout CaffeinatorConfig) in
                    config.enabled = isEnabled
                }
            } catch {
                self.logger.error(error)
            }
        }
    }
}
