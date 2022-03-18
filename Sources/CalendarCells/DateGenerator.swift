import Foundation

extension Date {
  static func generator(from start: Date,
                        to end: Date,
                        calendar: Calendar = .current) -> AnyIterator<Date> {
    var current: Date? = start
    return AnyIterator {
      guard
        let date = current,
        date <= end
      else { return nil }

      defer {
        current = calendar.date(byAdding: .day, value: 1, to: date)
      }

      return date
    }
  }
}
