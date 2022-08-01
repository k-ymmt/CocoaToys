//
//  Published.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/07/31.
//

import Foundation
import Combine

@propertyWrapper
public struct PassthroughPublished<Output> {
    private let subject = PassthroughSubject<Output, Never>()

    public var wrappedValue: RelayPublisher<Output> {
        RelayPublisher(subject)
    }

    public init() {
    }

    public func send(_ input: Output) {
        subject.send(input)
    }
}

public extension PassthroughPublished where Output == Void {
    func send() {
        subject.send(())
    }
}

@propertyWrapper
public struct CurrentValuePublished<Output> {
    private let subject: CurrentValueSubject<Output, Never>

    public var wrappedValue: RelayPublisher<Output> {
        RelayPublisher(subject)
    }

    public init(value: Output) {
        self.subject = CurrentValueSubject(value)
    }

    public func send(_ input: Output) {
        subject.send(input)
    }
}

public extension CurrentValuePublished where Output == Void {
    func send() {
        subject.send(())
    }
}
