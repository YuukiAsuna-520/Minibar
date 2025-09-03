//
//  Models.swift
//  Minibar
//
//  Created by 黑白熊 on 3/9/2025.
//

//  Purpose:
//  Domain models and protocols that define the app's core data
//  and behaviors. These types are UI-agnostic and can be reused across views,
//  viewmodels, and tests.
//
//  - Each item has its own stable `id` so UI lists can diff reliably.
//  - Protocols here describe high-level capabilities (order management,
//    scheduling) without tying to a concrete storage implementation.
import Foundation

// MARK: - Domain Models

/// Represents a purchasable minibar product
struct Product: Identifiable, Equatable {
    /// Stable identifier for UI diffing and comparisons.
    let id: UUID = UUID()
    /// Display name shown to the guest.
    var name: String
    /// Unit price for a single item.
    var price: Double
}

/// A single order line for a given room.
/// Multiple taps on the same product can be merged into quantity by the store.
struct OrderItem: Identifiable, Equatable {
    /// Stable identifier for editing/deleting a specific line.
    let id: UUID = UUID()
    /// The product being ordered.
    var product: Product
    /// How many units of the product were ordered.
    var quantity: Int
    /// The room number this order line belongs to (e.g., "0808").
    var room: String
    /// Creation timestamp (used for simple sorting in history).
    var createdAt: Date = Date()
}

/// A visit window during which staff will service the minibar for a room.
struct TimeSlot: Equatable {
    /// Stable identifier if you want to display/edit in lists.
    let id: UUID = UUID()
    /// Start time of the visit window.
    var start: Date
    /// End time of the visit window (must be after `start`).
    var end: Date
}

// MARK: - Protocols (Protocol-Oriented Design)

/// Capabilities required by any order manager
///
/// Conforming types are responsible for keeping `orders` consistent
/// (e.g., merging same-room same-product lines if desired).
protocol OrderManaging {
    /// The current collection of order lines in memory.
    var orders: [OrderItem] { get set }

    /// Adds a new order line (or merges with an existing one).
    /// - Parameter item: The order to insert/merge.
    func add(_ item: OrderItem)

    /// Removes an order line by its identifier.
    /// - Parameter id: The `OrderItem.id` to remove.
    func delete(_ id: UUID)

    /// Updates an existing order line in-place, matched by `OrderItem.id`.
    /// - Parameter item: The modified order line to persist.
    func update(_ item: OrderItem)
}

/// Scheduling capability for saving/clearing a room's selected service window.
/// Typically implemented by the app's store as the single source of truth.
protocol Scheduling {
    /// The currently scheduled (persisted) time slot; `nil` if none saved.
    var scheduledSlot: TimeSlot? { get set }
}
