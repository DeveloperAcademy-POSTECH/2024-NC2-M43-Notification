//
//  QuizRow.swift
//  NC2-Notification
//
//  Created by 이윤학 on 6/17/24.
//

import SwiftUI

struct QuizRow: View {
    let quiz: Quiz
    let dateFormatter: DateFormatter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PushDate
            Spacer().frame(height: 4)
            ProblemText
            Spacer().frame(height: 16)
            AnswerList
        }
        .padding(.horizontal, 24)
        .padding(.top, 14)
        .padding(.bottom, 28)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.25), radius: 2.5)
        }
    }
}

extension QuizRow {
    private var PushDate: some View {
        HStack {
            Spacer()
            Text("\(formattedDate(quiz.date))")
                .font(.pretendard(weight: .medium, size: 10))
                .foregroundStyle(.nc2Gray100)
        }
    }
    
    private var ProblemText: some View {
        Text("Q. \(quiz.problem)")
            .font(.pretendard(weight: .bold, size: 17))
            .lineLimit(2)
    }
    
    private var AnswerList: some View {
        VStack(spacing: 9) {
            ForEach(0..<quiz.options.count, id: \.self) { index in
                let isAnswer = index == quiz.answerNumber
                HStack {
                    Text("\(index+1)) \(quiz.options[index])")
                    Spacer()
                }
                .font(.pretendard(weight: .semiBold, size: 15))
                .overlay(alignment: .trailing) {
                    if isAnswer {
                        Image(systemName: "checkmark.circle")
                            .foregroundStyle(.nc2Green100)
                            .bold()
                            .font(.system(size: 20))
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(isAnswer ? .nc2Green20 : .nc2Gray20)
                        .shadow(color: .black.opacity(0.25), radius: 2.5)
                }
                .overlay {
                    if isAnswer {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.nc2Green100, lineWidth: 0.8)
                    }
                }
            }
        }
    }
}

extension QuizRow {
    private func formattedDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}

//#Preview {
//    QuizRow()
//}
