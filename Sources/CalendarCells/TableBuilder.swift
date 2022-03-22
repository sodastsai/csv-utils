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
