//
//  CaffeinatorServiceType.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/08/06.
//

import Foundation

public protocol CaffeinatorServiceType {
    func start() async throws
    func stop() async
}
