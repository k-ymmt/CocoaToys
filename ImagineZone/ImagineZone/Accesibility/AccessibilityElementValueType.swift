//
//  AccessibilityElementValueType.swift
//  ImagineZone
//
//  Created by Kazuki Yamamoto on 2022/07/27.
//

import Foundation
import ApplicationServices

protocol AccessibilityElementValueType {
    static var axValueType: AXValueType { get }
}

extension CGPoint: AccessibilityElementValueType {
    static var axValueType: AXValueType {
        .cgPoint
    }
}

extension CGRect: AccessibilityElementValueType {
    static var axValueType: AXValueType {
        .cgRect
    }
}

extension CGSize: AccessibilityElementValueType {
    static var axValueType: AXValueType {
        .cgSize
    }
}
