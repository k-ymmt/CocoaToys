//
//  AXError+Extensions.swift
//  ImagineZone
//
//  Created by Kazuki Yamamoto on 2022/07/27.
//

import Foundation
import ApplicationServices

extension AXError: Error {
    var key: String {
        switch self {
        case .success:
            return "Success"
        case .actionUnsupported:
            return "Action unsupported"
        case .apiDisabled:
            return "API disabled"
        case .attributeUnsupported:
            return "Attribute unsupported"
        case .cannotComplete:
            return "Can't complete"
        case .failure:
            return "Failure"
        case .illegalArgument:
            return "Illegal argument"
        case .invalidUIElement:
            return "Invalid UI Element"
        case .invalidUIElementObserver:
            return "Invalid UI element observer"
        case .noValue:
            return "No value"
        case .notEnoughPrecision:
            return "Not enough percision"
        case .notImplemented:
            return "Not implemented"
        case .notificationAlreadyRegistered:
            return "Notification already registered"
        case .notificationNotRegistered:
            return "Notification not registered"
        case .notificationUnsupported:
            return "Notification unsupported"
        case .parameterizedAttributeUnsupported:
            return "Parameterized attribute unsupported"
        @unknown default:
            return "Unknown"
        }
    }
}

extension AXError: CustomStringConvertible {
    public var description: String {
        "(\(rawValue))\(key)"
    }
}
