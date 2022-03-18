import Foundation

extension Date {
  init(year: Int, month: Int, day: Int, calendar: Calendar = .unitedKingdom) {
    guard let date = DateComponents(
      calendar: calendar,
      timeZone: calendar.timeZone,
      year: year,
      month: month,
      day: day
    ).date else {
      fatalError("Failed to create date for testing - year: \(year), month: \(month), day: \(day)")
    }
    self = date
  }
}

extension Calendar {
  static let unitedKingdom: Calendar = {
    guard let londonTimeZone = TimeZone(identifier: "Europe/London") else {
      fatalError("Cannot create 'Europe/London' TimeZone")
    }
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_GB")
    calendar.timeZone = londonTimeZone
    return calendar
  }()
}
