//
//  RelayPublisher.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/07/31.
//

import Foundation
import Combine

public struct RelayPublisher<Output>: Publisher {
    public typealias Failure = Never
    
    private let publisher: any Publisher<Output, Never>

    public init(_ publisher: some Publisher<Output, Never>) {
        self.publisher = publisher
    }

    public func receive<S: Subscriber>(subscriber: S) where S.Input == Output, S.Failure == Never {
        publisher.receive(subscriber: subscriber)
    }
}

public extension Publisher where Failure == Never {
    func relayPublisher() -> RelayPublisher<Output> {
        RelayPublisher(self)
    }
}
