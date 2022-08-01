//
//  Task+Extensions.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/07/31.
//

import Foundation
import Combine

public extension Task {
    func store(in set: inout Set<AnyCancellable>) {
        set.insert(AnyCancellable {
            if isCancelled {
                cancel()
            }
        })
    }
}
