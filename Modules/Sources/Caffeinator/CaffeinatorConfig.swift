//
//  CaffeinatorConfig.swift
//  Caffeinator
//
//  Created by Kazuki Yamamoto on 2022/07/31.
//

import Foundation
import CocoaToysKit

struct CaffeinatorConfig: ConfigType {
    enum NoSleepType: String, Codable {
        case display
        case idle
    }
    var enabled: Bool
    var noSleepType: NoSleepType
}

extension CaffeinatorConfig {
    enum CodingKeys: String, CodingKey {
        case enabled
        case noSleepType = "no_sleep_type"
    }
}

extension CaffeinatorConfig {
    static var fileName: String {
        "caffeinator"
    }
}
