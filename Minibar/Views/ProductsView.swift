//
//  ProductsView.swift
//  Minibar
//
//  Created by 黑白熊 on 3/9/2025.
//

import SwiftUI

struct ProductsView: View {
    @EnvironmentObject var store: AppStore
    let room: String

    // Only remember the last tapped row to flash
    @State private var lastAddedID: UUID? = nil
    private let flashDuration: TimeInterval = 0.5

    var body: some View {
        List {
            ForEach(store.products) { p in
                let isFlashed = (lastAddedID == p.id)

                HStack {
                    VStack(alignment: .leading) {
                        Text(p.name).font(.headline)
                        Text(String(format: "$%.2f", p.price))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button("Add") {
                        // 1) add to orders
                        let item = OrderItem(product: p, quantity: 1, room: room)
                        store.add(item)

                        // 2) flash UI feedback
                        lastAddedID = p.id
                        withAnimation(.easeInOut(duration: 0.15)) { }
                        DispatchQueue.main.asyncAfter(deadline: .now() + flashDuration) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if lastAddedID == p.id { lastAddedID = nil }
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isFlashed)                 // avoid spamming while flashing
                    .opacity(isFlashed ? 0.5 : 1.0)      // dim button during flash
                }
                .listRowBackground(isFlashed ? Color.gray.opacity(0.18) : Color.clear)
            }
        }
        .navigationTitle("Products")
    }
}

#Preview {
    ProductsView(room: "0808").environmentObject(AppStore())
}
