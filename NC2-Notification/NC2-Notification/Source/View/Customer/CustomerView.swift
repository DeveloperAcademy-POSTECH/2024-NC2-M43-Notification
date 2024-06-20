//
//  CustomerView.swift
//  NC2-Notification
//
//  Created by 이윤학 on 6/18/24.
//

import SwiftUI
import SwiftData

struct CustomerView: View {
    @Environment(\.dismiss) private var dismiss
    @State var selectedAnswer: Int? = nil
    @State var quizIndex: Int? = 0
    @State var showRewardSheet: Bool = false
    @Query var quizzes: [Quiz]
    
    var quiz: Quiz {
        if let index = quizIndex {
            return quizzes[index]
        } else {
            return Quiz()
        }
    }
    
    var isRightSelection: Bool {
        selectedAnswer == quiz.answerNumber
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if selectedAnswer == nil {
                Spacer().frame(height: 40)
                ProblemText
                Spacer().frame(height: 50)
            } else if isRightSelection {
                Image(.answerBanner)
                Spacer().frame(height: 20)
                Rectangle().frame(width: 90, height: 1)
                    .foregroundStyle(.nc2Gray120)
                Spacer().frame(height: 20)
                ProblemText
                Spacer().frame(height: 20)
            } else {
                Image(.wrongAnswerBanner)
                Spacer().frame(height: 20)
                Rectangle().frame(width: 90, height: 1)
                    .foregroundStyle(.nc2Gray120)
                Spacer().frame(height: 20)
                ProblemText
                Spacer().frame(height: 20)
            }
            AnswerList
            Spacer()
            Description
            Spacer().frame(height: 12)
            QuizRewordButton
            Spacer().frame(height: 4)
            backHomeButton
        }
        .padding(20)
        .background(.nc2Blue20)
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showRewardSheet) {
            Image(.reward)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

extension CustomerView {
    private var ProblemText: some View {
        Text("Q. \(quiz.problem)")
            .font(.pretendard(weight: .semiBold, size: 22))
            .multilineTextAlignment(.center)
    }
    
    private var AnswerList: some View {
        VStack(spacing: 14) {
            ForEach(0..<quiz.options.count, id: \.self) { index in
                let selectValueExist = selectedAnswer != nil
                let isSelected = index == selectedAnswer
                let isAnswer = index == quiz.answerNumber
                
                Button {
                    selectedAnswer = index
                } label: {
                    HStack {
                        Text("\(index+1)) \(quiz.options[index])")
                            .foregroundStyle(.black)
                        Spacer()
                    }
                    .font(.pretendard(weight: .bold, size: 20))
                    .overlay(alignment: .trailing) {
                        if isSelected {
                            Image(systemName: "checkmark.circle")
                                .foregroundStyle(isAnswer ? .nc2Green100
                                                          : .nc2Red100)
                                .bold()
                                .font(.system(size: 20))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(selectValueExist&&isAnswer ? .nc2Green20 : .white)
                            .shadow(color: .black.opacity(0.25), radius: 2.5)
                    }
                    .overlay {
                        if selectValueExist && isAnswer {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.nc2Green100, lineWidth: 0.8)
                        }
                    }
                }
                .disabled(selectValueExist)
            }
        }
    }
    
    private var Description: some View {
        VStack(spacing: 6) {
            if isRightSelection {
                Image(.coupangPlay)
                Text("무료 체험 응모권 받아가세요!")
                    .font(.pretendard(weight: .semiBold, size: 15))
                    .foregroundStyle(.nc2Gray110)
            } else {
                Text("다른 문제 풀고 상품 응모권을 받아가세요!")
                    .font(.pretendard(weight: .semiBold, size: 15))
                    .foregroundStyle(.nc2Gray110)
            }
        }
    }
    
    private var QuizRewordButton: some View {
        Button {
            if isRightSelection {
                showRewardSheet = true
            } else {
                quizIndex = Int.random(in: 0..<quizzes.count)
                selectedAnswer = nil
            }
        } label: {
            HStack {
                Spacer()
                Text(isRightSelection ? "상품 응모권 받기  🎁"
                                      : "다른 문제 풀기 💡")
                .foregroundStyle(.white)
                .font(.pretendard(weight: .semiBold, size: 20))
                Spacer()
            }
            .padding(.vertical, 18)
            .background {
                RoundedRectangle(cornerRadius: 13)
                    .foregroundStyle(.nc2Blue100)
                    .shadow(color: .black.opacity(0.25), radius: 2.5)
            }
        }
    }
    
    private var backHomeButton: some View {
        Button {
            dismiss()
        } label: {
            Text("홈화면으로 돌아가기")
                .underline(color: .nc2Gray80)
                .foregroundStyle(.nc2Gray80)
                .font(.pretendard(weight: .medium, size: 12))
                .padding(12)
        }
    }
}

#Preview {
    CustomerView()
}
