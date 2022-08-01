//
//  AccessibilityManager.swift
//  ImagineZone
//
//  Created by Kazuki Yamamoto on 2022/07/27.
//

import Foundation
import ApplicationServices

struct AccessibilityManager {
    func requestTrust() async {
        if AXIsProcessTrustedWithOptions([kAXTrustedCheckOptionPrompt.takeUnretainedValue(): kCFBooleanTrue] as CFDictionary) {
            return
        }
        while true {
            if isTrusted() {
                return
            }
            try? await Task.sleep(nanoseconds: 1000)
        }
    }

    func isTrusted() -> Bool {
        AXIsProcessTrusted()
    }
}
