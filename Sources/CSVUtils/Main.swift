import ArgumentParser
import CalendarCells

@main
struct CSVUtils: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "A boilerplate for generating CSV content.",
    subcommands: [
      CalendarCellsCommand.self,
    ]
  )
}
