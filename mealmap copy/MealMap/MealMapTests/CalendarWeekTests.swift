import Foundation
import XCTest
@testable import MealMap

final class CalendarWeekTests: XCTestCase {
    func testWeekAlwaysStartsOnSunday() {
        var components = DateComponents()
        components.year = 2026
        components.month = 10
        components.day = 28 // Wednesday
        let wednesday = CalendarWeek.calendar.date(from: components)!

        let days = CalendarWeek.days(inWeekContaining: wednesday)
        XCTAssertEqual(days.count, 7)
        XCTAssertEqual(CalendarWeek.calendar.component(.weekday, from: days[0]), 1)
        XCTAssertEqual(CalendarWeek.calendar.component(.weekday, from: days[6]), 7)
        XCTAssertTrue(CalendarWeek.isSameDay(days[3], wednesday))
    }

    func testStartOfWeekIsStableAcrossDaysInTheSameWeek() {
        var components = DateComponents()
        components.year = 2026
        components.month = 10
        components.day = 25 // Sunday
        let sunday = CalendarWeek.calendar.date(from: components)!
        let saturday = CalendarWeek.calendar.date(byAdding: .day, value: 6, to: sunday)!

        XCTAssertTrue(CalendarWeek.isSameDay(
            CalendarWeek.startOfWeek(containing: sunday),
            CalendarWeek.startOfWeek(containing: saturday)
        ))
    }

    func testAddingWeeksMovesSundayToSunday() {
        var components = DateComponents()
        components.year = 2026
        components.month = 3
        components.day = 8
        let date = CalendarWeek.calendar.date(from: components)!
        let next = CalendarWeek.addingWeeks(1, to: date)
        XCTAssertEqual(CalendarWeek.calendar.component(.weekday, from: next), 1)
        XCTAssertEqual(
            CalendarWeek.calendar.dateComponents([.day], from: CalendarWeek.startOfWeek(containing: date), to: next).day,
            7
        )
    }
}
