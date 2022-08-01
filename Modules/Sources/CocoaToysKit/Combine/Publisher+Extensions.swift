//
//  Publisher+Extensions.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/07/31.
//

import Foundation
import Combine

public struct CurrentValuePublisher<P: Publisher>: Publisher {
    public typealias Output = P.Output
    public typealias Failure = P.Failure

    private let publisher: P

    public init(_ publisher: P) {
        self.publisher = publisher
    }

    public func receive<S: Subscriber>(subscriber: S) where P.Failure == S.Failure, P.Output == S.Input {
        publisher
            .map { Optional.some($0) }
            .multicast(subject: CurrentValueSubject<Output?, Failure>(nil))
            .autoconnect()
            .compactMap { $0 }
            .receive(subscriber: subscriber)
    }
}

public extension Publisher {
    func shareReplay() -> CurrentValuePublisher<some Publisher<Output, Failure>> {
        CurrentValuePublisher(self)
    }
}
