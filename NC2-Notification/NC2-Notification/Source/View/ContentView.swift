//
//  ContentView.swift
//  NC2-Notification
//
//  Created by 이윤학 on 6/17/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var quizzes: [Quiz]
    @State private var showEditorSheet: Bool = false
    @State private var isEditing: Bool = false
    @State private var editTargetIndex: Int? = nil
    
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
        NavigationStack {
            List {
                ForEach(quizzes) { quiz in
                    Button {
                        editQuiz(quiz: quiz)
                    } label: {
                        QuizListRow(quiz: quiz)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        registerQuiz()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("문제 목록")
        }
        .sheet(isPresented: $showEditorSheet) {
            QuizFormView(isEditing: $isEditing,
                         editTargetIndex: $editTargetIndex)
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Quiz(problem: "새로운 문제입니다",
                               options: ["선택지", "선택지", "선택지"],
                               answerNumber: 0,
                               date: .now)
            modelContext.insert(newItem)
        }
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
    ContentView()
        .modelContainer(for: Quiz.self, inMemory: true)
}
