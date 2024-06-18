//
//  QuizMakerView.swift
//  NC2-Notification
//
//  Created by 이윤학 on 6/17/24.
//

import SwiftUI
import SwiftData

struct QuizMakerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var quizzes: [Quiz]
    
    @State private var showEditorSheet: Bool = false
    @State private var isEditing: Bool = false
    @State private var editTargetIndex: Int? = nil
    
    let pushManager = NotificationManager.instance
    
    var body: some View {
        NavigationStack {
            QuizList
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    AddButton
                }
            }
            .navigationTitle("문제를 저장하세요!📂")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.nc2Blue)
        }
        .sheet(isPresented: $showEditorSheet) {
            QuizFormView(isEditing: $isEditing,
                         editTargetIndex: $editTargetIndex)
        }
        .onAppear {
            pushManager.requestAuthorization()
            pushManager.removeNotification()
        }
    }
}

extension QuizMakerView {
    private var QuizList: some View {
        List {
            ForEach(quizzes) { quiz in
                Button {
                    editQuiz(quiz: quiz)
                } label: {
                    QuizRow(quiz: quiz, dateFormatter: dateFormatter)
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color.nc2Blue)
            }
            .onDelete(perform: deleteItems)
        }
        .contentMargins(.top, 16, for: .scrollContent)
        .listStyle(.plain)
    }
    
    private var AddButton: some View {
        Button {
            registerQuiz()
        } label: {
            Image(systemName: "plus")
                .fontWeight(.semibold)
        }
    }
}

extension QuizMakerView {
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd(EEE) H시 mm분"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(quizzes[index])
            }
        }
    }
    
    private func editQuiz(quiz: Quiz) {
        showEditorSheet = true
        isEditing = true
        editTargetIndex = quizzes.firstIndex(of: quiz)
    }
    
    private func registerQuiz() {
        isEditing = false
        editTargetIndex = nil
        showEditorSheet = true
    }
}


#Preview {
    QuizMakerView()
        .modelContainer(for: Quiz.self, inMemory: true)
}
