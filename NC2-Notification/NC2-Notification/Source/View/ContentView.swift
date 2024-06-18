//
//  ContentView.swift
//  NC2-Notification
//
//  Created by 이윤학 on 6/18/24.
//

import SwiftUI

struct ContentView: View {
    let pushManager = NotificationManager.instance
    
    var body: some View {
        Main()
            .onAppear {
                pushManager.requestAuthorization()
                pushManager.removeNotification()
            }
    }
}

#Preview {
    ContentView()
}
