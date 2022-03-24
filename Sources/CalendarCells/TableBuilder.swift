import Foundation

struct TableBuilder {
  enum Cell {
    case header(String)
    case empty
    case date(Date)
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

  var bodyRows: [Row] {
    makeDateCells()
  }

  func build() -> Table {
    var table = Table()
    if options.withHeader {
      table.append(headerRow)
    }
    table.append(contentsOf: bodyRows)
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

  func makeDateCells() -> [Row] {
    let weekdaysCount = calendar.weekdaySymbols.count
    var rows = [Row()]
    rows.lastRow += Array(repeating: .empty, count: paddingSizeBeforeStartDate)
    for date in Date.generator(from: startDate, to: endDate) {
      if rows.lastRow.count == weekdaysCount {
        rows.append([])
      }
      rows.lastRow.append(.date(date))
    }
    rows.lastRow += Array(repeating: .empty, count: paddingSizeAfterEndDate)
    return rows
  }
}

private func mod<Value: BinaryInteger>(_ value: Value, by divisor: Value) -> Value {
  let result = value % divisor
  return result >= 0 ? result : result + divisor
}

extension TableBuilder.Table {
  var lastRow: TableBuilder.Row {
    get { self[endIndex - 1] }
    set { self[endIndex - 1] = newValue }
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
