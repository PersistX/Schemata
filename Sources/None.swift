/// The unit type, equivalent to Swift's `Void`.
///
/// Because `Void` is the empty tuple, `()`, and tuples aren't full types in Swift, `Void` is
/// somewhat limited. Of particular concern is the inability for `Void` to conform to protocols.
/// This type serves as an equivalent type that doesn't suffer from the same restrictions.
public struct None: Hashable {
    public static let none = None()

    private init() {}
}

extension None: ModelValue {
    public static let value = Value<None, None>()
}
