import ArgumentParser

@main
struct CSVUtils: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "A boilerplate for generating CSV content."
  )
}
