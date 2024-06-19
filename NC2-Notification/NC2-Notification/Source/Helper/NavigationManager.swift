//
//  NavigationManager.swift
//  NC2-Notification
//
//  Created by 이윤학 on 6/19/24.
//

import SwiftUI

enum PathType: Hashable {
    case main
    case quizMaker
    case customer(selectedAnswer: Int?, quizIndex: Int?)
}

extension PathType {
    @ViewBuilder
    func NavigatingView() -> some View {
        switch self {
        case .main:
            Main()
        case .quizMaker:
            QuizMakerView()
        case .customer(let selectedAnswer, let quizIndex):
            CustomerView(selectedAnswer: selectedAnswer, quizIndex: quizIndex)
        }
    }
}

@Observable
class NavigationManager {
    static let shared = NavigationManager()
    private init() {}
    
    var path: [PathType] = []
}

extension NavigationManager {
    func push(to pathType: PathType) {
        path.append(pathType)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
    
    func pop(to pathType: PathType) {
        guard let lastIndex = path.lastIndex(of: pathType) else { return }
        path.removeLast(path.count - (lastIndex + 1))
    }
    
    func pushNotificatinoResult(selectedAnswer: Int?, quizIndex: Int?) {
        popToRoot()
        push(to: .customer(selectedAnswer: selectedAnswer, quizIndex: quizIndex))
    }
}

extension PathType: Equatable {
    static func ==(lhs: PathType, rhs: PathType) -> Bool {
        switch (lhs, rhs) {
        case (.main, .main),
             (.quizMaker, .quizMaker),
             (.customer, .customer):
            return true
        default:
            return false
        }
    }
}
