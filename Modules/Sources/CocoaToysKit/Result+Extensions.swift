//
//  Result+Extensions.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/07/31.
//

import Foundation
import Combine

public protocol ResultProtocol {
    associatedtype Success
    associatedtype Failure
    var success: Success? { get }
    var failure: Failure? { get }
}

extension Result: ResultProtocol {
    public var success: Success? {
        guard case let .success(success) = self else {
            return nil
        }
        return success
    }

    public var failure: Failure? {
        guard case let .failure(failure) = self else {
            return nil
        }
        return failure
    }


}
