//
//  ContentView.swift
//  NC2-Notification
//
//  Created by 이윤학 on 6/18/24.
//

import SwiftUI

struct ContentView: View {
    let pushManager = NotificationManager.instance
    @State private var navigationManager = NavigationManager.shared
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            Main()
                .onAppear {
                    pushManager.requestAuthorization()
                    pushManager.removeNotification()
                }
                .navigationDestination(for: PathType.self) { path in
                    path.NavigatingView()
                }
        }
    }
}

#Preview {
    ContentView()
}
