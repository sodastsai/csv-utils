import ArgumentParser
import Foundation

private extension ParseStrategy where Self == Date.ParseStrategy {
  static var `default`: Date.ParseStrategy {
    .fixed(
      format: "\(day: .defaultDigits)/\(month: .defaultDigits)/\(year: .defaultDigits)",
      timeZone: .autoupdatingCurrent
    )
  }
}

extension Date: ExpressibleByArgument {
  static let argumentFormatHelp = "In d/M/y format"

  public init?(argument: String) {
    guard let date = try? Date(argument, strategy: .default) else { return nil }
    self = date
  }
}
