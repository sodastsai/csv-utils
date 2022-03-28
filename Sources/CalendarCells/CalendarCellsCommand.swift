import ArgumentParser
import Foundation

public struct CalendarCellsCommand: ParsableCommand {
  public static var configuration = CommandConfiguration(
    commandName: "calendar-cells"
  )

  @Argument(help: "First date of the calendar, \(Date.argumentFormatHelp).")
  public var startDate: Date

  @Argument(help: "Last date of the calendar, \(Date.argumentFormatHelp).")
  public var endDate: Date

  @Option(help: "Number of empty rows beteen date rows, for note.")
  public var noteRows = 1

  public init() {}

  public func run() throws {
    let builder = TableBuilder(from: startDate,
                               to: endDate,
                               calendar: .current,
                               options: [
                                 .withHeader,
                                 .withMonthName,
                                 .withNoteRows(noteRows),
                               ])
    let csvString = try builder.build().toCSVString()
    print(csvString)
  }
}
