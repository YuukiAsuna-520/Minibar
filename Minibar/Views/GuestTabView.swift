//
//  GuestTabView.swift
//  Minibar
//
//  Created by 黑白熊 on 3/9/2025.
//

import SwiftUI
/// Shows three tabs: Products, Time Slot, and Order History.
struct GuestTabView: View {
    /// (Injected from the login flow; default only for preview/dev.)
    var room: String = "0808"
    /// Callback used by the History tab to sign the user out.
    var onSignOut: () -> Void = {}

    var body: some View {
        TabView {
            // MARK: - Products tab
            NavigationStack {
                // Product list where the guest can add items for this room.
                ProductsView(room: room)
            }
            .tabItem { Label("Products", systemImage: "cart") }
            
            // MARK: - Time slot tab
            NavigationStack {
                // Uses AppStore via EnvironmentObject
                // Pick and manage a delivery time slot.
                TimeSlotView()
            }
            .tabItem { Label("Time Slot", systemImage: "clock") }
            
            // MARK: - Order history tab
            NavigationStack {
                // Shows orders for the current room with edit/delete + Sign out.
                OrderHistoryView(room: room, onSignOut: onSignOut)
            }
            .tabItem { Label("History", systemImage: "list.bullet") }
        }
    }
}

#Preview {
    // Minimal preview: inject an AppStore so child views work.
    GuestTabView().environmentObject(AppStore())
}
