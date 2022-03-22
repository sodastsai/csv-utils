@testable import CalendarCells
import XCTest

// MARK: - Test

class TableBuilderTests: XCTestCase {
  // MARK: Headers

  func testHeadersWithStartingByMonday() {
    let table = makeTable(from: Date(), to: Date(), calendar: makeCalendar(firstWeekday: 2))
    XCTAssertEqual(stringify(row: table.first ?? []),
                   ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"])
  }

  func testHeadersWithStartingBySaturday() {
    let table = makeTable(from: Date(), to: Date(), calendar: makeCalendar(firstWeekday: 7))
    XCTAssertEqual(stringify(row: table.first ?? []),
                   ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"])
  }

  func testHeadersWithStartingByOtherDays() {
    let table = makeTable(from: Date(), to: Date(), calendar: makeCalendar(firstWeekday: 4))
    XCTAssertEqual(stringify(row: table.first ?? []),
                   ["Wednesday", "Thursday", "Friday", "Saturday", "Sunday", "Monday", "Tuesday"])
  }

  // MARK: Empty date padding

  func testCellPaddingsBetweenWeekdayEnds1() {
    let tableGenerator = TableBuilder(from: Date(year: 2022, month: 1, day: 1),
                                      to: Date(year: 2022, month: 1, day: 1),
                                      calendar: makeCalendar(firstWeekday: 4))
    XCTAssertEqual(tableGenerator.paddingSizeBeforeStartDate, 3)
    XCTAssertEqual(tableGenerator.paddingSizeAfterEndDate, 3)
  }

  func testCellPaddingsBetweenWeekdayEnds2() {
    let tableGenerator = TableBuilder(from: Date(year: 2022, month: 1, day: 26),
                                      to: Date(year: 2022, month: 1, day: 27),
                                      calendar: makeCalendar(firstWeekday: 6))
    XCTAssertEqual(tableGenerator.paddingSizeBeforeStartDate, 5)
    XCTAssertEqual(tableGenerator.paddingSizeAfterEndDate, 0)
  }

  func testCellPaddingsBetweenWeekdayEnds3() {
    let tableGenerator = TableBuilder(from: Date(year: 2022, month: 1, day: 25),
                                      to: Date(year: 2022, month: 1, day: 27),
                                      calendar: makeCalendar(firstWeekday: 3))
    XCTAssertEqual(tableGenerator.paddingSizeBeforeStartDate, 0)
    XCTAssertEqual(tableGenerator.paddingSizeAfterEndDate, 4)
  }
}

// MARK: - Test Utils

private func makeCalendar(firstWeekday: Int = 2) -> Calendar {
  var calendar = Calendar(identifier: .gregorian)
  calendar.locale = .autoupdatingCurrent
  calendar.firstWeekday = firstWeekday
  return calendar
}

private func stringify(table: TableBuilder.Table) -> [[String]] {
  table.map(stringify(row:))
}

private func stringify(row: TableBuilder.Row) -> [String] {
  row.map(stringify(cell:))
}

private func stringify(cell: TableBuilder.Cell) -> String {
  switch cell {
  case let .header(header):
    return header
  }
}
