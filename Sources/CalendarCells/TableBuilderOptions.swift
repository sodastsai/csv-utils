//

extension TableBuilder {
  enum Option {
    case withHeader
    case withMonthName
    case withNoteRows(Int)
  }

  typealias Options = Set<Option>
}

extension TableBuilder.Option: Hashable {}

extension TableBuilder.Options {
  static let `default`: Self = [
    .withHeader,
    .withMonthName,
  ]

  var numberOfNoteRows: Int {
    compactMap { option in
      guard case let .withNoteRows(noteRows) = option else { return nil }
      return noteRows
    }.reduce(0, +)
  }
}
