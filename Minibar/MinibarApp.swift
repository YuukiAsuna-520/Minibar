//
//  MinibarApp.swift
//  Minibar
//
//  Created by 黑白熊 on 2/9/2025.
//

import SwiftUI

@main
struct MinibarApp: App {
    @StateObject private var store = AppStore()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store) // Implement to all child views
        }
    }
}
