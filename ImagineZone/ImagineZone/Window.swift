//
//  Window.swift
//  ImagineZone
//
//  Created by Kazuki Yamamoto on 2022/07/25.
//

import Foundation
import Cocoa
import Carbon

func bar() {
    Task.detached {
        await AccessibilityManager().requestTrust()

        let apps = WindowManager.windowList()
            .filter { $0.ownerName == "Google Chrome.app" }
            .map(AccessibilityElement.init)

        let mainScreenFrame = NSScreen.screens[0].frame
        let frame = NSScreen.main!.frame
        let size = frame.size
        let x = frame.origin.x
        let y = mainScreenFrame.height - frame.maxY
        let centerX = x + size.width / 2
        let centerY = y + size.height / 2

        for app in apps {
            do {
                let rawWindows = try app.attributeValue(.windows)
                let windows = rawWindows.map(AccessibilityElement.init(element:))

                for window in windows {
                    let windowSize = try window.attributeValue(.size)
                    let x = centerX - windowSize.width / 2
                    let y = centerY - windowSize.height / 2
                    try window.setAttributeValue(.position, value: .init(x: x, y: y))
                }
            } catch {
                print(error)
            }
        }
    }
}

private extension AccessibilityElement {
    init(_ pid: pid_t) {
        self.init(element: AXUIElementCreateApplication(pid))
    }
    init(_ info: WindowInfo) {
        self.init(pid: info.id)
    }
}
