//
//  ConfigType.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/07/31.
//

import Foundation

public protocol ConfigType: Codable, Equatable {
    static var fileName: String { get }
}
