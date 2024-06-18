//
//  Main.swift
//  NC2-Notification
//
//  Created by 이윤학 on 6/18/24.
//

import SwiftUI

struct Main: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer().frame(height: 36)
                Title
                Spacer().frame(height: 24)
                Banner
                Spacer().frame(height: 32)
                RoleButtonSection
                Spacer()
            }
            .padding(20)
            .background(Color.nc2Blue)
        }
    }
}

extension Main {
    var Title: some View {
        HStack {
            Text("어서오세요,\n노티퀴즈 🔔 입니다!")
                .font(.pretendard(weight: .bold, size: 30))
            Spacer()
        }
    }
    
    var Banner: some View {
        Image(.main)
            .resizable()
            .scaledToFill()
            .frame(width: 300, height: 224)
    }
    
    var RoleButtonSection: some View {
        VStack(spacing: 16) {
            NavigationLink {
                QuizMakerView()
            } label: {
                RoleButton(role: .maker)
            }
            
            NavigationLink {
                Text("Customer")
            } label: {
                RoleButton(role: .customer)
            }
        }
    }
}

#Preview {
    Main()
}
