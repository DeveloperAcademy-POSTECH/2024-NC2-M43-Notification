//
//  Font+.swift
//  NC2-Notification
//
//  Created by 이윤학 on 6/17/24.
//

import SwiftUI

extension Font {
    static func pretendard(weight: PretendardWeight, size: CGFloat) -> Font {
        return Font.custom("Pretendard-\(weight.rawValue)", size: size)
    }
}

enum PretendardWeight: String {
    case bold = "Bold"
    case semiBold = "SemiBold"
    case regular = "Regular"
    case medium = "Medium"
}
