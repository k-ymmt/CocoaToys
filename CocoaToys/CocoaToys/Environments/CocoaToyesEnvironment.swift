//
//  CocoaToyesEnvironment.swift
//  CocoaToys
//
//  Created by Kazuki Yamamoto on 2022/07/30.
//

import Foundation
import CocoaToysKit
import Dependencies
import Caffeinator

final class CocoaToysEnvironment: AppEnvironment {
    var fileManager: FileManager {
        .default
    }

    lazy var configManager: ConfigManager = CocoaToysConfigManager(fileManager: fileManager) 

    var caffeinatorService: CaffeinatorServiceType {
        CaffeinatorService(manager: configManager)
    }
}
