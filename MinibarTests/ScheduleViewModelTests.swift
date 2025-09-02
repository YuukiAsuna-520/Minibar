//
//  ScheduleViewModelTests.swift
//  MinibarTests
//
//  Created by 黑白熊 on 2/9/2025.
//

import XCTest
@testable import Minibar

final class ScheduleViewModelTests: XCTestCase {

    func test_invalidTimeSlot_setsError() {
        let vm = ScheduleViewModel()
        vm.start = Date()
        vm.end   = vm.start
        vm.save()
        XCTAssertEqual(vm.errorMessage, "Invalid time slot")
        XCTAssertFalse(vm.didSave)
    }

    func test_validTimeSlot_saves() {
        let vm = ScheduleViewModel()
        vm.start = Date()
        vm.end   = vm.start.addingTimeInterval(1800)
        vm.save()
        XCTAssertNil(vm.errorMessage)
        XCTAssertTrue(vm.didSave)
    }

    func test_saveFailure_setsError() {
        let vm = ScheduleViewModel()
        vm.saveShouldFail = true
        vm.start = Date()
        vm.end   = vm.start.addingTimeInterval(1800)
        vm.save()
        XCTAssertEqual(vm.errorMessage, "Failed to save task")
        XCTAssertFalse(vm.didSave)
    }
}
