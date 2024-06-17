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
    
    var body: some View {
        NavigationStack {
            QuizList
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    AddButton
                }
            }
            .navigationTitle("문제 목록")
        }
        .sheet(isPresented: $showEditorSheet) {
            QuizFormView(isEditing: $isEditing,
                         editTargetIndex: $editTargetIndex)
        }
    }
}

extension ContentView {
    private var QuizList: some View {
        List {
            ForEach(quizzes) { quiz in
                Button {
                    editQuiz(quiz: quiz)
                } label: {
                    QuizListRow(quiz: quiz, dateFormatter: dateFormatter)
                }
            }
            .onDelete(perform: deleteItems)
        }
        .listStyle(.plain)
    }
    
    private var AddButton: some View {
        Button {
            registerQuiz()
        } label: {
            Label("Add Item", systemImage: "plus")
        }
    }
}

extension ContentView {
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd(EEE) H시"
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
    ContentView()
        .modelContainer(for: Quiz.self, inMemory: true)
}
