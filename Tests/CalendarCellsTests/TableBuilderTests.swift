@testable import CalendarCells
import XCTest

// MARK: - Test

class TableBuilderTests: XCTestCase {
  // MARK: Headers

  func testHeadersWithStartingByMonday() {
    let table = makeTable(from: Date(),
                          to: Date(),
                          calendar: makeCalendar(firstWeekday: 2),
                          options: [.withHeader, .withMonthName])
    XCTAssertEqual(stringify(row: table.first ?? []),
                   ["Month", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"])
  }

  func testHeadersWithStartingBySaturday() {
    let table = makeTable(from: Date(),
                          to: Date(),
                          calendar: makeCalendar(firstWeekday: 7),
                          options: [.withHeader])
    XCTAssertEqual(stringify(row: table.first ?? []),
                   ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"])
  }

  func testHeadersWithStartingByOtherDays() {
    let table = makeTable(from: Date(),
                          to: Date(),
                          calendar: makeCalendar(firstWeekday: 4),
                          options: [.withHeader])
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

  // MARK: Date cells

  func testGeneratingDateCells() {
    let tableGenerator = TableBuilder(from: Date(year: 2022, month: 3, day: 15),
                                      to: Date(year: 2022, month: 4, day: 1),
                                      calendar: makeCalendar(firstWeekday: 2),
                                      options: [.withHeader])
    XCTAssertEqual(stringify(table: tableGenerator.build()),
                   [
                     ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
                     ["", "15", "16", "17", "18", "19", "20"],
                     ["21", "22", "23", "24", "25", "26", "27"],
                     ["28", "29", "30", "31", "1", "", ""],
                   ])
  }

  // MARK: With Note Rows

  func testWithNoteRows() {
    let tableGenerator = TableBuilder(from: Date(year: 2022, month: 3, day: 15),
                                      to: Date(year: 2022, month: 4, day: 1),
                                      calendar: makeCalendar(firstWeekday: 2),
                                      options: [.withHeader, .withNoteRows(2)])
    XCTAssertEqual(stringify(table: tableGenerator.build()),
                   [
                     ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
                     ["", "15", "16", "17", "18", "19", "20"],
                     ["", "", "", "", "", "", ""],
                     ["", "", "", "", "", "", ""],
                     ["21", "22", "23", "24", "25", "26", "27"],
                     ["", "", "", "", "", "", ""],
                     ["", "", "", "", "", "", ""],
                     ["28", "29", "30", "31", "1", "", ""],
                     ["", "", "", "", "", "", ""],
                     ["", "", "", "", "", "", ""],
                   ])
  }

  func testWithNoteRowsAndMonthName() {
    let tableGenerator = TableBuilder(from: Date(year: 2022, month: 3, day: 23),
                                      to: Date(year: 2022, month: 4, day: 13),
                                      calendar: makeCalendar(firstWeekday: 2),
                                      options: [.withHeader, .withMonthName, .withNoteRows(2)])
    XCTAssertEqual(stringify(table: tableGenerator.build()),
                   [
                     ["Month", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
                     ["March", "", "", "23", "24", "25", "26", "27"],
                     ["", "", "", "", "", "", "", ""],
                     ["", "", "", "", "", "", "", ""],
                     ["", "28", "29", "30", "31", "1", "2", "3"],
                     ["", "", "", "", "", "", "", ""],
                     ["", "", "", "", "", "", "", ""],
                     ["April", "4", "5", "6", "7", "8", "9", "10"],
                     ["", "", "", "", "", "", "", ""],
                     ["", "", "", "", "", "", "", ""],
                     ["", "11", "12", "13", "", "", "", ""],
                     ["", "", "", "", "", "", "", ""],
                     ["", "", "", "", "", "", "", ""],
                   ])
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
  case .empty:
    return ""
  case let .date(date):
    return date.formatted(.dateTime.day())
  }
}
