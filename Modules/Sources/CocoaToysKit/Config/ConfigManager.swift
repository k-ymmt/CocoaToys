//
//  ConfigManager.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/07/30.
//

import Foundation
import Combine

public enum ConfigManagerError: Error {
    case readFailed(Error)
    case decodeFailed(Error)
    case fileNotFound
}

public protocol ConfigManager {
    func fileChanged<Config: ConfigType>(_ configType: Config.Type) -> AnyPublisher<Result<Config, ConfigManagerError>, Never>
    func save(config: some ConfigType) async throws
    func createIfNotExists<Config: ConfigType>(defaultConfig: @autoclosure  () -> Config) async throws
    func isExists(config: ConfigType.Type) -> Bool
}
