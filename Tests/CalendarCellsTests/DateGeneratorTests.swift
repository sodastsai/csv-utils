@testable import CalendarCells
import XCTest

func dateList<Generator>(from generator: Generator) -> [String]
  where Generator: IteratorProtocol, Generator.Element == Date {
  IteratorSequence(generator).map {
    $0.formatted(date: .abbreviated, time: .complete)
  }
}

func dateList(from start: Date, to end: Date, calendar: Calendar = .unitedKingdom) -> [String] {
  dateList(from: Date.generator(from: start, to: end, calendar: calendar))
}

final class DateGeneratorTests: XCTestCase {
  func testDateGenerator() {
    let start = Date(year: 2021, month: 12, day: 28, calendar: .unitedKingdom)
    let end = Date(year: 2022, month: 1, day: 3, calendar: .unitedKingdom)
    XCTAssertEqual(dateList(from: start, to: end, calendar: .unitedKingdom),
                   [
                     "28 Dec 2021, 0:00:00 GMT",
                     "29 Dec 2021, 0:00:00 GMT",
                     "30 Dec 2021, 0:00:00 GMT",
                     "31 Dec 2021, 0:00:00 GMT",
                     "1 Jan 2022, 0:00:00 GMT",
                     "2 Jan 2022, 0:00:00 GMT",
                     "3 Jan 2022, 0:00:00 GMT",
                   ])
  }

  func testDateGeneratorOfLeapYear() {
    let start = Date(year: 2020, month: 2, day: 28, calendar: .unitedKingdom)
    let end = Date(year: 2020, month: 3, day: 1, calendar: .unitedKingdom)
    XCTAssertEqual(dateList(from: start, to: end, calendar: .unitedKingdom),
                   [
                     "28 Feb 2020, 0:00:00 GMT",
                     "29 Feb 2020, 0:00:00 GMT",
                     "1 Mar 2020, 0:00:00 GMT",
                   ])
  }

  func testDateGeneratorWithWrongDateRangeDirection() {
    let start = Date(year: 2020, month: 1, day: 5)
    let end = Date(year: 2020, month: 1, day: 3)
    XCTAssertEqual(dateList(from: start, to: end),
                   [])
  }

  func testDateGeneratorWithSummerTimeChange() {
    let start = Date(year: 2022, month: 3, day: 27, calendar: .unitedKingdom)
    let end = Date(year: 2022, month: 3, day: 28, calendar: .unitedKingdom)
    XCTAssertEqual(dateList(from: start, to: end, calendar: .unitedKingdom),
                   [
                     "27 Mar 2022, 0:00:00 GMT",
                     "28 Mar 2022, 0:00:00 BST",
                   ])
  }
}
