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

    var body: some View {
        NavigationStack {
            List {
                ForEach(quizzes) { quiz in
                    NavigationLink {
                        Text("수정뷰")
                    } label: {
                        Text(quiz.problem)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Quiz(problem: "새로운 문제입니다",
                               options: [],
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
