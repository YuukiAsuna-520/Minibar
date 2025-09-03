//
//  ScheduleViewModel.swift
//  Minibar
//
//  Created by 黑白熊 on 2/9/2025.
//

import Foundation
import Combine

/// Holds the editing state and validation logic for the Time Slot screen.
/// The AppStore contains only the *saved* slot (`scheduledSlot`), while this VM keeps a working copy during editing.
final class ScheduleViewModel: ObservableObject {

    // MARK: - Editing state (bound to the view)
    @Published var start: Date
    @Published var end: Date
    @Published var isEditing: Bool
    @Published var errorMessage: String?

    // MARK: - Init
    init() {
        // Start with a sensible default (next 30-min boundary, 30-min duration)
        let defaults = ScheduleViewModel.defaultSlot()
        self.start = defaults.start
        self.end = defaults.end
        self.isEditing = true
        self.errorMessage = nil
    }

    // MARK: - Public API

    /// Load the saved slot from the store (call onAppear).
    func load(from store: AppStore) {
        if let saved = store.scheduledSlot {
            start = saved.start
            end = saved.end
            isEditing = false
        } else {
            // nothing saved yet; keep default editable state
            isEditing = true
        }
        errorMessage = nil
    }

    /// Enter editing mode; prefill with saved values if any.
    func beginEditing(from store: AppStore) {
        if let saved = store.scheduledSlot {
            start = saved.start
            end = saved.end
        }
        isEditing = true
        errorMessage = nil
    }

    /// Validate and save into the AppStore. Returns true on success.
    @discardableResult
    func save(to store: AppStore) -> Bool {
        if let error = validate() {
            errorMessage = error
            return false
        }
        store.scheduledSlot = TimeSlot(start: start, end: end)
        isEditing = false
        errorMessage = nil
        return true
    }

    /// Remove the saved slot and return to a fresh editable state.
    func delete(from store: AppStore) {
        store.scheduledSlot = nil
        let defaults = Self.defaultSlot()
        start = defaults.start
        end = defaults.end
        isEditing = true
        errorMessage = nil
    }

    // MARK: - Validation

    /// Returns an error message if invalid; nil when OK.
    private func validate() -> String? {
        if end <= start {
            return "End time must be after start time."
        }
        let diff = end.timeIntervalSince(start)
        if diff <= 29 * 60 {
            return "Time slot must be at least 30 minutes."
        }
        if diff >= 5 * 60 * 60 {
            return "Time slot cannot exceed 5 hours."
        }
        return nil
    }

    // MARK: - Defaults

    /// Default slot: next 30-minute boundary, 30 minutes long.
    static func defaultSlot() -> TimeSlot {
        let cal = Calendar.current
        let now = Date()
        let minute = cal.component(.minute, from: now)
        let delta = 30 - (minute % 30)
        let rounded = cal.date(byAdding: .minute, value: delta, to: now) ?? now
        let end = cal.date(byAdding: .minute, value: 30, to: rounded) ?? rounded.addingTimeInterval(30 * 60)
        return TimeSlot(start: rounded, end: end)
    }
}
