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
    @State private var showRegisterSheet: Bool = false
    @State private var isEditing: Bool = false
    
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
                        showRegisterSheet = true
                        isEditing = false
                    } label: {
                        VStack(alignment: .leading) {
                            Text("\(formattedDate(quiz.date))")
                                .font(.caption)
                            Text("Q. \(quiz.problem)")
                                .font(.headline)
                                .lineLimit(2)
                            Text("1. \(quiz.options[0] ?? ""), 2. \(quiz.options[1] ?? ""), 3. \(quiz.options[2] ?? "")\nA. \(quiz.options[quiz.answerNumber] ?? "")")
                                .font(.subheadline)
                                .foregroundStyle(.black.opacity(0.6))
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addItem()
                        showRegisterSheet = true
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("문제 목록")
        }
        .sheet(isPresented: $showRegisterSheet) {
            Text("Sheet")
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Quiz(problem: "새로운 문제입니다",
                               options: [0 : "선택지", 1 : "선택지", 2 : "선택지"],
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
}

#Preview {
    ContentView()
        .modelContainer(for: Quiz.self, inMemory: true)
}
