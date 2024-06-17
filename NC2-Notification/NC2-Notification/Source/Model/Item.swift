//
//  Item.swift
//  NC2-Notification
//
//  Created by 이윤학 on 6/17/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
