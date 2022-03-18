@testable import ArgumentParser
@testable import CalendarCells
import XCTest

final class DateArgumentTests: XCTestCase {
  struct Command: ParsableCommand {
    @Argument(help: "Some date argument. \(Date.argumentFormatHelp).")
    var date: Date
  }

  func testArgumentHelpMessage() {
    XCTAssertEqual(Command.helpMessage(), """
    USAGE: command <date>

    ARGUMENTS:
      <date>                  Some date argument. In d/M/y format.

    OPTIONS:
      -h, --help              Show help information.

    """)
  }

  func testParseValidDateArgument() throws {
    let cmd = try Command.parse(["31/3/2022"])
    XCTAssertEqual(cmd.date, Date(year: 2022, month: 3, day: 31, calendar: .current))
  }

  func testParsingBadDateArgument() {
    XCTAssertThrowsError(try Command.parse(["31/A/2022"])) { error in
      guard let commandError = error as? CommandError,
            case .unableToParseValue = commandError.parserError
      else {
        XCTFail("\(error) should be a CommandError")
        return
      }
    }
  }
}
