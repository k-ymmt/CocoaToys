//
//  CaffeinatorStatusMenuItemEnvironment.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/08/06.
//

import Foundation
import CocoaToysKit

public protocol CaffeinatorStatusMenuItemEnvironment {
    var configManager: ConfigManager { get }
    var caffeinatorService: CaffeinatorServiceType { get }
    var caffeinatorLogger: Logging { get }
}
