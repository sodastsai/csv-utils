//

extension TableBuilder.Options {
  static let withHeader = Self(as: .withHeader)
}

extension TableBuilder.Options {
  static let `default`: Self = [
    .withHeader,
  ]
}

// MARK: - Initializer with value offsets

private extension TableBuilder.Options {
  enum ValueShiftOffset: Int {
    case withHeader = 0
  }

  init(as offset: ValueShiftOffset) {
    self = Self(rawValue: 1 << offset.rawValue)
  }
}
