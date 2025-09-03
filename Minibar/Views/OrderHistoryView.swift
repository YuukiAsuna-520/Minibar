//
//  OrderHistoryView.swift
//  Minibar
//
//  Created by 黑白熊 on 3/9/2025.
//

//  Purpose:
//  Shows the current room's order history, with swipe actions to edit or delete
//  individual lines, and a Sign Out action that bubbles up via `onSignOut`.
//
//  Interaction contract:
//  - Data source comes from `AppStore.orders`, filtered by `room`.
//  - Edit: opens a sheet with a Stepper to adjust quantity, then calls
//    `store.update(_:)`.
//  - Delete: swipe-to-delete calls `store.delete(_:)` by `OrderItem.id`.
//  - Sign out: calls the provided `onSignOut` callback; parent view (RootView)
//    decides how to clear session and navigate.
import SwiftUI

/// History list for a specific room with inline edit/delete actions.
struct OrderHistoryView: View {

    // MARK: - Dependencies

    /// Shared app state.
    @EnvironmentObject var store: AppStore

    // MARK: - Parameters

    /// The room whose orders are displayed.
    let room: String

    /// Callback invoked when the user taps "Sign out".
    let onSignOut: () -> Void

    // MARK: - Local UI State

    /// The order line being edited (nil when not editing).
    @State private var editing: OrderItem? = nil

    /// Draft quantity for the editor sheet.
    @State private var qtyDraft: Int = 1

    // MARK: - Derived Data

    /// Orders that belong to the current room, newest first.
    var roomOrders: [OrderItem] {
        store.orders
            .filter { $0.room == room }
            .sorted(by: { $0.createdAt > $1.createdAt })
    }

    // MARK: - View Body

    var body: some View {
        VStack {
            if roomOrders.isEmpty {
                // Empty state when no orders exist for this room.
                ContentUnavailableView(
                    "No orders yet",
                    systemImage: "tray",
                    description: Text("Add items from the Products tab.")
                )
            } else {
                // Non-empty: list with swipe actions per row.
                List {
                    ForEach(roomOrders) { item in
                        HStack {
                            Text(item.product.name)
                            Spacer()
                            Text("×\(item.quantity)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .swipeActions(edge: .trailing) {
                            // Delete action (destructive).
                            Button(role: .destructive) {
                                store.delete(item.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                            // Edit action opens a sheet to adjust quantity.
                            Button {
                                editing = item
                                qtyDraft = item.quantity
                            } label: {
                                Label("Edit", systemImage: "square.and.pencil")
                            }
                            .tint(.gray)
                        }
                    }
                }
            }

            // Sign out button sits below the list/empty state.
            Button("Sign out", action: onSignOut)
                .buttonStyle(.bordered)
                .padding(.bottom, 10)
        }
        .navigationTitle("Order History")
        // Editor sheet for changing quantity of the selected order line.
        .sheet(item: $editing) { order in
            NavigationStack {
                Form {
                    Stepper("Quantity: \(qtyDraft)", value: $qtyDraft, in: 1...20)
                }
                .navigationTitle("Edit Order")
                .toolbar {
                    // Cancel closes the sheet without saving.
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { editing = nil }
                    }
                    // Save writes back to the store via `update(_:)`.
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            var updated = order
                            updated.quantity = qtyDraft
                            store.update(updated)
                            editing = nil
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    OrderHistoryView(room: "0808", onSignOut: {})
        .environmentObject(AppStore())
}
