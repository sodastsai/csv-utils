@testable import CalendarCells
import XCTest

// MARK: - Test

class TableBuilderTests: XCTestCase {
  // MARK: Headers

  func testHeadersWithStartingByMonday() {
    let table = makeTable(calendar: makeCalendar(firstWeekday: 2))
    XCTAssertEqual(stringify(row: table.first ?? []),
                   ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"])
  }

  func testHeadersWithStartingBySaturday() {
    let table = makeTable(calendar: makeCalendar(firstWeekday: 7))
    XCTAssertEqual(stringify(row: table.first ?? []),
                   ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"])
  }

  func testHeadersWithStartingByOtherDays() {
    let table = makeTable(calendar: makeCalendar(firstWeekday: 4))
    XCTAssertEqual(stringify(row: table.first ?? []),
                   ["Wednesday", "Thursday", "Friday", "Saturday", "Sunday", "Monday", "Tuesday"])
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
