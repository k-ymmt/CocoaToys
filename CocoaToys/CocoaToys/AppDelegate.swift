//
//  AppDelegate.swift
//  CocoaToys
//
//  Created by Kazuki Yamamoto on 2022/07/28.
//

import Foundation
import AppKit
import SwiftUI

@main
final class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    var statusMenuItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.disableRelaunchOnLogin()

        let statusMenuItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusMenuItem.menu = CocoaToysStatusBarMenu()
        statusMenuItem.button?.image = NSImage(named: "status_menu")
        statusMenuItem.behavior = .removalAllowed
        self.statusMenuItem = statusMenuItem
    }

    func applicationWillTerminate(_ notification: Notification) {
        print("Terminated.")
    }
}
