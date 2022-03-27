//

extension TableBuilder.Options {
  static let withHeader = Self(as: .withHeader)
  static let withMonthName = Self(as: .withMonthName)

  static func with(noteRows: UInt8) -> Self {
    Self(rawValue: Int(noteRows) << ValueShiftOffset.noteRowsLowerBound.rawValue)
  }
}

extension TableBuilder.Options {
  static let `default`: Self = [
    .withHeader,
    .withMonthName,
  ]
}

// MARK: - Associated Values

extension TableBuilder.Options {
  var numberOfNoteRows: Int {
    rawValue >> ValueShiftOffset.noteRowsLowerBound.rawValue
  }
}

// MARK: - Initializer with value offsets

private extension TableBuilder.Options {
  enum ValueShiftOffset: Int {
    case withHeader = 0
    case withMonthName
    case noteRowsLowerBound
  }

  init(as offset: ValueShiftOffset) {
    self = Self(rawValue: 1 << offset.rawValue)
  }
}
