//
//  RootView.swift
//  Minibar
//
//  Created by 黑白熊 on 3/9/2025.
//

import SwiftUI

struct RootView: View {
    @State private var currentRoom: String? = nil  // Whether login or not

    var body: some View {
        if let room = currentRoom {
            GuestTabView(room: room, onSignOut: { currentRoom = nil })
        } else {
            LoginView { room in
                currentRoom = room
            }
        }
    }
}

#Preview {
    RootView().environmentObject(AppStore())
}
