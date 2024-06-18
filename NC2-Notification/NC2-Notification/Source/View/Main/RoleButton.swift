//
//  RoleButton.swift
//  NC2-Notification
//
//  Created by 이윤학 on 6/18/24.
//

import SwiftUI

struct RoleButton: View {
    let role: Role
    
    var body: some View {
        HStack {
            RoleText
            Spacer()
            RoleImage
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 18)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.25), radius: 4)
        }
    }
}

extension RoleButton {
    var RoleText: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(role.rawValue) 모드")
                .foregroundStyle(.nc2Gray120)
                .font(.pretendard(weight: .semiBold, size: 24))
            Text(role.description)
                .foregroundStyle(.nc2Gray120)
                .font(.pretendard(weight: .medium, size: 15))
        }
    }
    
    var RoleImage: some View {
        Text(role.imoji)
            .font(.system(size: 38))
    }
}

#Preview {
    RoleButton(role: .maker)
}

enum Role: String, CaseIterable {
    case maker = "출제자"
    case customer = "참여자"
    
    var description: String {
        switch self {
        case .maker: return "문제를 출제하고, 수정할 수 있습니다."
        case .customer: return "출제된 문제를 알림을 통해 풀어봅니다."
        }
    }
    
    var imoji: String {
        switch self {
        case .maker: return "🛠️"
        case .customer: return "✍️"
        }
    }
}
