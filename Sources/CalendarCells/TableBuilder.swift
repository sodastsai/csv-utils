import Foundation

struct TableBuilder {
  enum Cell {
    case header(String)
  }

  typealias Row = [Cell]

  typealias Table = [Row]

  let startDate: Date
  let endDate: Date
  let calendar: Calendar

  init(from startDate: Date,
       to endDate: Date,
       calendar: Calendar = .current,
       options: Options = .init()) {
    self.startDate = startDate
    self.endDate = endDate
    self.calendar = calendar
    self.options = options
  }

  // MARK: Options

  struct Options {
    var withHeader = true
  }

  var options: Options
}

// MARK: - Build Cells

extension TableBuilder {
  var headerRow: Row {
    let rawWeekdays = calendar.weekdaySymbols
    let firstWeekdayIndex = calendar.firstWeekday - 1
    let weekdays = rawWeekdays[firstWeekdayIndex...] + rawWeekdays[..<firstWeekdayIndex]
    return weekdays.map { .header($0) }
  }

  func build() -> Table {
    var table = Table()
    if options.withHeader {
      table.append(headerRow)
    }
    return table
  }

  func weekday(of date: Date) -> Int {
    calendar.component(.weekday, from: date)
  }

  var paddingSizeBeforeStartDate: Int {
    mod(weekday(of: startDate) - calendar.firstWeekday,
        by: calendar.weekdaySymbols.count)
  }

  var paddingSizeAfterEndDate: Int {
    mod(calendar.firstWeekday - weekday(of: endDate) - 1,
        by: calendar.weekdaySymbols.count)
  }
}

private func mod<Value: BinaryInteger>(_ value: Value, by divisor: Value) -> Value {
  let result = value % divisor
  return result >= 0 ? result : result + divisor
}

// MARK: - Shortcut

func makeTable(
  from startDate: Date,
  to endDate: Date,
  calendar: Calendar = .current,
  options: TableBuilder.Options = .init()
) -> TableBuilder.Table {
  TableBuilder(from: startDate, to: endDate, calendar: calendar, options: options).build()
}
