//
//  QuizListRow.swift
//  NC2-Notification
//
//  Created by 이윤학 on 6/17/24.
//

import SwiftUI

struct QuizListRow: View {
    let quiz: Quiz
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd(EEE)"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
    
    private func formattedDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(formattedDate(quiz.date))")
                .font(.caption)
            Text("Q. \(quiz.problem)")
                .font(.headline)
                .lineLimit(2)
            Text("1. \(quiz.options[0]), 2. \(quiz.options[1]), 3. \(quiz.options[2])\nA. \(quiz.options[quiz.answerNumber])")
                .font(.subheadline)
                .foregroundStyle(.black.opacity(0.6))
        }
    }
}

//#Preview {
//    QuizListRow()
//}
