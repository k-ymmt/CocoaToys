//
//  Environment.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/07/31.
//

import Foundation
import Combine

public protocol Environment {
    var configManager: ConfigManager { get }
}

#if DEBUG
public final class MockEnvironment: Environment {
    public init() {
    }
    
    public var configManager: ConfigManager {
        final class Mock: ConfigManager {
            var config: (any ConfigType)?
            func fileChanged<Config: ConfigType>(_ configType: Config.Type) -> AnyPublisher<Result<Config, ConfigManagerError>, Never> {
                Just(.success(config as! Config)).eraseToAnyPublisher()
            }

            func createIfNotExists<Config>(defaultConfig: @autoclosure () -> Config) async throws where Config : ConfigType {
            }

            func isExists(config: ConfigType.Type) -> Bool {
                true
            }

            func save(config: some ConfigType) async throws {
                self.config = config
            }
        }

        return Mock()
    }
}
#endif
