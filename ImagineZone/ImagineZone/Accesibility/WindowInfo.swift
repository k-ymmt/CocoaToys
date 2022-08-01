//
//  WindowInfo.swift
//  ImagineZone
//
//  Created by Kazuki Yamamoto on 2022/07/27.
//

import Foundation
import ApplicationServices

struct WindowInfo {
    private let info: [String: AnyObject]
    private let pid: Int

    init?(info: [String: AnyObject]) {
        self.info = info
        guard let pid = info[kCGWindowOwnerPID as String] as? Int else {
            return nil
        }
        self.pid = pid
    }

    var ownerName: String? {
        info[kCGWindowOwnerName as String] as? String
    }

    var layer: Int? {
        info[kCGWindowLayer as String] as? Int
    }
}

extension WindowInfo: Identifiable {
    var id: Int {
        pid
    }
}

extension WindowInfo: Hashable {
    static func == (lhs: WindowInfo, rhs: WindowInfo) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
