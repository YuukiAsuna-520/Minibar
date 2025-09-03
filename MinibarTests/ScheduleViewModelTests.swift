//
//  ScheduleViewModelTests.swift
//  MinibarTests
//
//  Created by 黑白熊 on 2/9/2025.
//

import XCTest
@testable import Minibar

final class ScheduleViewModelTests: XCTestCase {

    var store: AppStore!
    var vm: ScheduleViewModel!

    override func setUp() {
        super.setUp()
        store = AppStore()
        vm = ScheduleViewModel()
    }

    override func tearDown() {
        store = nil
        vm = nil
        super.tearDown()
    }

    /// Saving a valid time range should succeed, persist to the store,
    /// clear the error message and leave edit mode.
    func test_validTimeSlot_savePersistsToStore() {
        let start = Date()
        let end = start.addingTimeInterval(30 * 60)

        vm.start = start
        vm.end = end

        let ok = vm.save(to: store)
        XCTAssertTrue(ok)
        XCTAssertNotNil(store.scheduledSlot)
        XCTAssertEqual(
            store.scheduledSlot!.start.timeIntervalSinceReferenceDate,
            start.timeIntervalSinceReferenceDate,
            accuracy: 1
        )
        XCTAssertEqual(
            store.scheduledSlot!.end.timeIntervalSinceReferenceDate,
            end.timeIntervalSinceReferenceDate,
            accuracy: 1
        )
        XCTAssertNil(vm.errorMessage)
        XCTAssertFalse(vm.isEditing)
    }

    /// If end time is earlier than start time, saving should fail,
    /// the store should remain empty, and an error message should be set.
    func test_invalidTimeSlot_isRejected() {
        let start = Date()
        let end = start.addingTimeInterval(-60)

        vm.start = start
        vm.end = end

        let ok = vm.save(to: store)
        XCTAssertFalse(ok)
        XCTAssertNil(store.scheduledSlot)
        XCTAssertNotNil(vm.errorMessage)
    }

    /// Deleting should remove the scheduled slot from the store.
    func test_deleteClearsSlot() {
        store.scheduledSlot = TimeSlot(
            start: Date(),
            end: Date().addingTimeInterval(1800)
        )
        vm.delete(from: store)
        XCTAssertNil(store.scheduledSlot)
    }

    /// beginEditing should load the slot from the store into the VM
    /// and switch the VM into editing mode.
    func test_beginEditingLoadsFromStore() {
        let start = Date()
        let end = start.addingTimeInterval(1800)
        store.scheduledSlot = TimeSlot(start: start, end: end)

        vm.beginEditing(from: store)

        XCTAssertTrue(vm.isEditing)
        XCTAssertEqual(vm.start.timeIntervalSinceReferenceDate,
                       start.timeIntervalSinceReferenceDate,
                       accuracy: 1)
        XCTAssertEqual(vm.end.timeIntervalSinceReferenceDate,
                       end.timeIntervalSinceReferenceDate,
                       accuracy: 1)
    }
}
