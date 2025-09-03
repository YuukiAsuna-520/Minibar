//
//  MinibarTests.swift
//  MinibarTests
//
//  Created by 黑白熊 on 2/9/2025.
//

import XCTest
@testable import Minibar

@MainActor
final class MinibarTests: XCTestCase {
    var store: AppStore!

    override func setUp() {
        super.setUp()
        store = AppStore()
    }

    func testAddAndDeleteOrder() {
        let p = Product(name: "Test", price: 1)
        let item = OrderItem(product: p, quantity: 1, room: "0808")

        store.add(item)
        XCTAssertEqual(store.orders.count, 1)

        store.delete(item.id)
        XCTAssertEqual(store.orders.count, 0)
    }

    func testUpdateOrderChangesQuantity() {
        let p = Product(name: "Test", price: 1)
        var item = OrderItem(product: p, quantity: 1, room: "0808")

        store.add(item)
        item.quantity = 3
        store.update(item)

        XCTAssertEqual(store.orders.first?.quantity, 3)
    }
}
