//
//  QuizRegisterSheet.swift
//  NC2-Notification
//
//  Created by 이윤학 on 6/17/24.
//

import SwiftUI
import SwiftData

struct QuizFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var quizzes: [Quiz]
    
    @State private var newQuiz: Quiz = Quiz()
    
    @Binding var isEditing: Bool
    @Binding var editTargetIndex: Int?
    
    let manager = NotificationManager.instance
    
    var body: some View {
        NavigationStack {
            Form {
                ProblemSection
                OptionSection
                AnswerSection
                DateSection
            }
            .navigationTitle(isEditing ? "퀴즈 수정" : "퀴즈 등록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CancelButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ApplyButton
                }
            }
            .onAppear {
                if isEditing {
                    applyTargetData()
                }
            }
        }
    }
}

extension QuizFormView {
    private var ProblemSection: some View {
        Section(header: Text("문제")) {
            TextField("문제를 입력하세요",
                      text: $newQuiz.problem)
        }
    }
    
    private var OptionSection: some View {
        Section(header: Text("선택지")) {
            ForEach(0..<3) { index in
                TextField("선택지 \(index + 1)",
                          text: $newQuiz.options[index])
            }
        }
    }
    
    private var AnswerSection: some View {
        Section(header: Text("정답")) {
            Picker("정답을 선택하세요", selection: $newQuiz.answerNumber) {
                ForEach(0..<3) { index in
                    Text(newQuiz.options[index].isEmpty ? "선택지 \(index + 1)"
                                                        : "\(newQuiz.options[index])")
                        .tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    private var DateSection: some View {
        Section {
            DatePicker("퀴즈 날짜",
                       selection: $newQuiz.date,
                       displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.compact)
        }
    }
    
    private var CancelButton: some View {
        Button("취소") {
            dismiss()
        }
    }
    
    private var ApplyButton: some View {
        Button {
            isEditing ? applyEditedData()
                      : saveData()
            dismiss()
        } label: {
            Text(isEditing ? "수정" : "등록")
                .bold()
        }
        .disabled(buttonDisabled)
    }
}

extension QuizFormView {
    private var buttonDisabled: Bool {
        return newQuiz.problem.isEmpty || newQuiz.options.contains("")
    }
    
    private func applyTargetData() {
        guard let targetIndex = editTargetIndex else { return }
        let targetQuiz = quizzes[targetIndex]
        
        newQuiz.problem = targetQuiz.problem
        newQuiz.options = targetQuiz.options
        newQuiz.answerNumber = targetQuiz.answerNumber
        newQuiz.date = targetQuiz.date
    }
    
    private func saveData() {
        modelContext.insert(newQuiz)
        if let quizIndex = quizzes.firstIndex(of: newQuiz) {
            manager.scheduleQuizNotification(quiz: newQuiz, quizIndex: quizIndex)
        }
       
    }
    
    private func applyEditedData() {
        guard let targetIndex = editTargetIndex else { return }
        let targetQuiz = quizzes[targetIndex]
        
        targetQuiz.problem = newQuiz.problem
        targetQuiz.options = newQuiz.options
        targetQuiz.answerNumber = newQuiz.answerNumber
        targetQuiz.date = newQuiz.date
        
        if let quizIndex = quizzes.firstIndex(of: targetQuiz) {
            manager.cancelNotificationRequst(identifier: targetQuiz.id)
            manager.scheduleQuizNotification(quiz: targetQuiz, quizIndex: targetIndex)
 
        }
        
    }
}

//#Preview {
//    QuizFormView()
//}
