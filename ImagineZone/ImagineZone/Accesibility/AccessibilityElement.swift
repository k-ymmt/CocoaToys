//
//  AccessibilityElement.swift
//  ImagineZone
//
//  Created by Kazuki Yamamoto on 2022/07/27.
//

import Foundation
import Cocoa

struct ImagineZoneError: Error {
    let message: String
}

struct AccessibilityElement {
    struct Attribute<ValueType> {
        static var windows: Attribute<[AXUIElement]> {
            .init(name: NSAccessibility.Attribute.windows as CFString)
        }
        static var position: Attribute<CGPoint> {
            .init(name: kAXPositionAttribute as CFString)
        }
        static var size: Attribute<CGSize> {
            .init(name: kAXSizeAttribute as CFString)
        }

        static var title: Attribute<String> {
            .init(name: NSAccessibility.Attribute.title as CFString)
        }

        fileprivate var name: CFString

        private init(name: CFString) {
            self.name = name
        }
    }

    let element: AXUIElement

    init(element: AXUIElement) {
        self.element = element
    }

    init(pid: Int) {
        self.init(element: AXUIElementCreateApplication(pid_t(pid)))
    }

    func isAttributeSettable<Value>(_ attribute: Attribute<Value>) -> Bool {
        var resizable: DarwinBoolean = true
        let error = AXUIElementIsAttributeSettable(element, attribute.name, &resizable)

        guard error == .success else {
            return false
        }

        return resizable.boolValue
    }

    func attributeValue<Value: AccessibilityElementValueType>(_ attribute: Attribute<Value>) throws -> Value {
        let rawValue = try rawAttributeValue(attribute.name)
        guard let rawValue, CFGetTypeID(rawValue) == AXValueGetTypeID() else {
            throw ImagineZoneError(message: "`value` cast failed. expected: \(Value.self), actual: \(String(describing: rawValue))")
        }
        let pointer = UnsafeMutablePointer<Value>.allocate(capacity: 1)
        defer { pointer.deallocate() }
        let successed = AXValueGetValue(rawValue as! AXValue, Value.axValueType, pointer)

        guard successed else {
            throw ImagineZoneError(message: "The structure stored in value is not the same as requested by \(Value.self)")
        }

        return pointer.pointee
    }

    func attributeValue<Value>(_ attribute: Attribute<Value>) throws -> Value {
        let rawValue = try rawAttributeValue(attribute.name)
        guard let value = rawValue as? Value else {
            throw ImagineZoneError(message: "`value` cast failed. expected: \(Value.self), actual: \(String(describing: rawValue))")
        }

        return value
    }

    func setAttributeValue<Value: AccessibilityElementValueType>(_ attribute: Attribute<Value>, value: Value) throws {
        var value = value
        guard let v = AXValueCreate(Value.axValueType, &value) else {
            throw ImagineZoneError(message: "Value creation failed. \(Value.axValueType): \(value)")
        }

        let error = AXUIElementSetAttributeValue(element, attribute.name, v)
        if error != .success {
            throw error
        }
    }
}

private extension AccessibilityElement {
    func rawAttributeValue(_ name: CFString) throws -> AnyObject? {
        var rawValue: CFTypeRef? = nil
        let error = AXUIElementCopyAttributeValue(
            element,
            name,
            &rawValue
        )
        guard error == .success else {
            throw error
        }

        return rawValue
    }
}
