//
//  TimeSlotView.swift
//  Minibar
//
//  Created by 黑白熊 on 3/9/2025.
//

import SwiftUI

struct TimeSlotView: View {
    @EnvironmentObject var store: AppStore
    @StateObject private var vm = ScheduleViewModel()

    var body: some View {
        VStack {
            Spacer()

            Group {
                if vm.isEditing || store.scheduledSlot == nil {
                    editorCard
                } else {
                    savedCard
                }
            }
            .frame(maxWidth: 340)
            .padding(.horizontal)

            Spacer()
        }
        .onAppear { vm.load(from: store) }
        .navigationTitle("Schedule")
    }

    // MARK: - Editor (when creating/updating a time slot)
    private var editorCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pick your service time slot")
                .font(.headline)

            VStack(alignment: .leading, spacing: 8) {
                Text("Start")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                DatePicker(
                    "",
                    selection: $vm.start,
                    displayedComponents: [.hourAndMinute]
                )
                .labelsHidden()
                .datePickerStyle(.wheel)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("End")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                DatePicker(
                    "",
                    selection: $vm.end,
                    displayedComponents: [.hourAndMinute]
                )
                .labelsHidden()
                .datePickerStyle(.wheel)
            }

            if let message = vm.errorMessage {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .padding(.top, 4)
            }

            HStack {
                Button("Cancel") {
                    // Revert to saved state (or defaults if none)
                    vm.load(from: store)
                }
                .buttonStyle(.bordered)

                Spacer()

                Button("Save") {
                    _ = vm.save(to: store)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.top, 8)

            Text("We will only come during your chosen time slot.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 2, y: 1)
    }

    // MARK: - Saved (shows the saved slot; swipe to edit/delete)
    private var savedCard: some View {
        let slot = store.scheduledSlot!

        return VStack(alignment: .leading, spacing: 12) {
            Text("Your scheduled time")
                .font(.headline)

            HStack {
                Image(systemName: "clock")
                Text("\(format(slot.start)) – \(format(slot.end))")
                    .font(.title3).bold()
            }

            Text("Long-press to edit or delete. Staff will visit within this slot.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 2, y: 1)
        .contextMenu {
                Button("Edit") {
                    vm.beginEditing(from: store)
                }
                Button("Delete", role: .destructive) {
                    vm.delete(from: store)
                }
        }
    }

    // MARK: - Helpers
    private func format(_ date: Date) -> String {
        Self.timeFormatter.string(from: date)
    }

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        f.dateStyle = .none
        return f
    }()
}

// MARK: - Preview
#Preview {
    let s = AppStore()
    s.scheduledSlot = TimeSlot(
        start: Date(),
        end: Calendar.current.date(byAdding: .minute, value: 45, to: Date())!
    )
    return NavigationStack {
        TimeSlotView()
            .environmentObject(s)
    }
}
