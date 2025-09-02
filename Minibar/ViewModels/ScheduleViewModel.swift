//
//  ScheduleViewModel.swift
//  Minibar
//
//  Created by 黑白熊 on 2/9/2025.
//

import Foundation

final class ScheduleViewModel: ObservableObject {
    @Published var start: Date = Date()
    @Published var end: Date   = Date().addingTimeInterval(30*60)
    @Published var errorMessage: String?
    @Published var didSave: Bool = false

    // For test: stimulate fail to save
    var saveShouldFail = false

    func save() {
        errorMessage = nil
        didSave = false

        guard end > start else {
            errorMessage = "Invalid time slot"
            return
        }
        if saveShouldFail {
            errorMessage = "Failed to save task"
            return
        }
        didSave = true
    }
}

