//
//  QuizListRow.swift
//  NC2-Notification
//
//  Created by 이윤학 on 6/17/24.
//

import SwiftUI

struct QuizListRow: View {
    let quiz: Quiz
    let dateFormatter: DateFormatter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            PushDate
            ProblemText
            AnswerList
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(.nc2Blue)
        }
    }
}

extension QuizListRow {
    private var PushDate: some View {
        Text("\(formattedDate(quiz.date))")
            .font(.pretendard(weight: .regular, size: 11))
    }
    
    private var ProblemText: some View {
        Text("Q. \(quiz.problem)")
            .font(.pretendard(weight: .bold, size: 20.5))
            .lineLimit(2)
    }
    
    private var AnswerList: some View {
        VStack(spacing: 8) {
            ForEach(0..<quiz.options.count, id: \.self) { index in
                HStack {
                    Text("\(index+1)) \(quiz.options[index])")
                    Spacer()
                }
                .font(.pretendard(weight: .regular, size: 14))
                .overlay(alignment: .trailing) {
                    if index == quiz.answerNumber {
                        Image(systemName: "checkmark.circle")
                            .foregroundStyle(.nc2Green)
                            .bold()
                            .font(.system(size: 20))
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

extension QuizListRow {
    private func formattedDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}

//#Preview {
//    QuizListRow()
//}
