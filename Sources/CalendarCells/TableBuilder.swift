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
       options: Options = .default) {
    self.startDate = startDate
    self.endDate = endDate
    self.calendar = calendar
    self.options = options
  }

  // MARK: Options

  struct Options: OptionSet {
    let rawValue: Int
  }

  var options: Options = .default
}

// MARK: - Build Cells

extension TableBuilder {
  var headerRow: Row {
    var row = makeWeekdayCells()
    if options.contains(.withMonthName) {
      row.insert(.header("Month"), at: 0)
    }
    return row
  }

  var bodyRows: [Row] {
    var bodyRows = makeDateRows()
    bodyRows = appendNoteRows(to: bodyRows, rowsCount: options.numberOfNoteRows)
    if options.contains(.withMonthName) {
      bodyRows = appendMonthName(to: bodyRows)
    }
    return bodyRows
  }

  func build() -> Table {
    var table = Table()
    if options.contains(.withHeader) {
      table.append(headerRow)
    }
    table.append(contentsOf: bodyRows)
    return table
  }

  func weekday(of date: Date) -> Int {
    calendar.component(.weekday, from: date)
  }

  func month(of date: Date) -> Int {
    calendar.component(.month, from: date)
  }

  var paddingSizeBeforeStartDate: Int {
    mod(weekday(of: startDate) - calendar.firstWeekday,
        by: calendar.weekdaySymbols.count)
  }

  var paddingSizeAfterEndDate: Int {
    mod(calendar.firstWeekday - weekday(of: endDate) - 1,
        by: calendar.weekdaySymbols.count)
  }

  func makeDateRows() -> [Row] {
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

  func makeWeekdayCells() -> [Cell] {
    let rawWeekdays = calendar.weekdaySymbols
    let firstWeekdayIndex = calendar.firstWeekday - 1
    let weekdays = rawWeekdays[firstWeekdayIndex...] + rawWeekdays[..<firstWeekdayIndex]
    return weekdays.map { .header($0) }
  }

  func appendNoteRows(to dateRows: [Row], rowsCount: Int) -> [Row] {
    guard rowsCount != 0 else {
      return dateRows
    }

    var rows = [Row]()
    let rowWidth = dateRows.map(\.count).min() ?? 0
    let numberOfNoteRows = options.numberOfNoteRows
    for dateRow in dateRows {
      rows.append(dateRow)
      for _ in 0 ..< numberOfNoteRows {
        rows.append(Row(repeating: .empty, count: rowWidth))
      }
    }
    return rows
  }

  func appendMonthName(to rows: [Row]) -> [Row] {
    var currentMonth: String?
    return rows.map { dateRow in
      guard
        let monthOfRow = dateRow.firstMonth(using: calendar),
        monthOfRow != currentMonth
      else {
        return [.empty] + dateRow
      }
      currentMonth = monthOfRow
      return [.header(monthOfRow)] + dateRow
    }
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

extension TableBuilder.Row {
  var firstDate: Date? {
    for cell in self {
      if case let .date(date) = cell {
        return date
      }
    }
    return nil
  }

  func firstMonth(using calendar: Calendar) -> String? {
    guard let firstDate = firstDate else { return nil }
    let monthIndex = calendar.component(.month, from: firstDate) - 1
    return calendar.monthSymbols[monthIndex]
  }
}

// MARK: - Shortcut

func makeTable(
  from startDate: Date,
  to endDate: Date,
  calendar: Calendar = .current,
  options: TableBuilder.Options = .default
) -> TableBuilder.Table {
  TableBuilder(from: startDate, to: endDate, calendar: calendar, options: options).build()
}
