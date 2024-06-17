//
//  Item.swift
//  NC2-Notification
//
//  Created by 이윤학 on 6/17/24.
//

import Foundation
import SwiftData

@Model
final class Quiz {
    var problem: String
    var options: [String]
    var answerNumber: Int
    var date: Date
    
    init(problem: String, options: [String], answerNumber: Int, date: Date) {
        self.problem = problem
        self.options = options
        self.answerNumber = answerNumber
        self.date = date
    }
}
