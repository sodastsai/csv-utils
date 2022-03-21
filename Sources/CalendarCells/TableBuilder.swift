import Foundation

struct TableBuilder {
  enum Cell {
    case header(String)
  }

  typealias Row = [Cell]

  typealias Table = [Row]

  let calendar: Calendar

  init(calendar: Calendar = .current, options: Options = .init()) {
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

func makeTable(calendar: Calendar = .current, options: TableBuilder.Options = .init()) -> TableBuilder.Table {
  TableBuilder(calendar: calendar, options: options).build()
}
