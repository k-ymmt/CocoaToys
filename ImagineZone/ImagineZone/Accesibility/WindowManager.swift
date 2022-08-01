//
//  WindowManager.swift
//  ImagineZone
//
//  Created by Kazuki Yamamoto on 2022/07/27.
//

import Foundation
import ApplicationServices

struct WindowManager {
    static func windowList() -> Set<WindowInfo> {
        let options = CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly)
        let windowListInfo = CGWindowListCopyWindowInfo(options, kCGNullWindowID)
        guard let infoList = (windowListInfo as NSArray?) as? [[String: AnyObject]] else {
            return []
        }

        return Set(infoList.compactMap(WindowInfo.init(info:)).filter { $0.layer == 0 })
    }
}
