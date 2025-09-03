//
//  AppStore.swift
//  Minibar
//
//  Created by 黑白熊 on 3/9/2025.
//

//  Purpose:
//  An observable, in-memory store for the app.
//  It exposes published state and conforms to the domain
//  protocols `OrderManaging` and `Scheduling`.
import Foundation
import Combine

/// Global application state container via `@EnvironmentObject`.
final class AppStore: ObservableObject, OrderManaging, Scheduling {

    // MARK: - Catalog

    /// In-memory product catalog shown to guests on the Products tab.
    @Published var products: [Product] = [
        Product(name: "Stone Wood",     price: 10),
        Product(name: "Young Henry",    price: 10),
        Product(name: "Fellr",          price: 10),
        Product(name: "Chardonnay",     price: 24),
        Product(name: "Shiraz",         price: 24),
        Product(name: "Coke",           price: 5),
        Product(name: "No Sugar Coke",  price: 5),
        Product(name: "Redbull",        price: 5),
        Product(name: "Sparkling Water",price: 5),
        Product(name: "Pringle",        price: 4),
        Product(name: "KitKat",         price: 4),
        Product(name: "Cadbury",        price: 4),
        Product(name: "Redrock Chips",  price: 4),
    ]

    // MARK: - Orders & Scheduling (published state consumed by views)

    /// Current order lines across rooms. Views typically filter by `room`.
    @Published var orders: [OrderItem] = []

    /// The currently scheduled slot for the active room.
    @Published var scheduledSlot: TimeSlot? = nil

    // MARK: - OrderManaging

    /// Adds a new order line, or merges quantity into an existing line for the same `room` and `product`.
    /// - If a line exists with the same room and product, increase its `quantity`
    ///   and refresh `createdAt` so it appears at the top of recency-sorted lists.
    /// - Parameter item: The order line to insert or merge.
    func add(_ item: OrderItem) {
        if let idx = orders.firstIndex(where: {
            $0.room == item.room && $0.product.id == item.product.id
        }) {
            orders[idx].quantity += item.quantity
            orders[idx].createdAt = Date() // keep most-recent ordering simple
        } else {
            orders.append(item)
        }
    }

    /// Removes a single order line by its id.
    /// - Parameter id: The `OrderItem.id` to remove.
    func delete(_ id: UUID) {
        if let idx = orders.firstIndex(where: { $0.id == id }) {
            orders.remove(at: idx)
        }
    }

    /// Replaces an existing order line matched by `OrderItem.id`.
    /// - Parameter item: The updated line.
    func update(_ item: OrderItem) {
        if let idx = orders.firstIndex(where: { $0.id == item.id }) {
            orders[idx] = item
        }
    }
}
