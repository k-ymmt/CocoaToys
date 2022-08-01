//
//  AppEnvironment.swift
//  CocoaToys
//
//  Created by Kazuki Yamamoto on 2022/07/30.
//

import Foundation
import CocoaToysKit
import Caffeinator

protocol AppEnvironment: CaffeinatorEnvironment {
}

#if DEBUG
final class MockEnvironment: AppEnvironment {
    let cocoaToysKitMock = CocoaToysKit.MockEnvironment()
    let caffeinatorMock = Caffeinator.MockEnvironment()

    var configManager: CocoaToysKit.ConfigManager {
        cocoaToysKitMock.configManager
    }

    var caffeinatorService: Caffeinator.CaffeinatorServiceType {
        caffeinatorMock.caffeinatorService
    }

}
#endif
