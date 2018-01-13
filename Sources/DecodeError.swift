import Foundation

public enum ValueError: Swift.Error {
    case typeMismatch
}

extension ValueError: Hashable {
    public var hashValue: Int {
        return 0
    }

    public static func == (_: ValueError, _: ValueError) -> Bool {
        return false
    }
}

public struct DecodeError: Error {
    public var errors: [String: ValueError]

    public init(_ errors: [String: ValueError]) {
        self.errors = errors
    }
}

extension DecodeError: Hashable {
    public var hashValue: Int {
        return errors
            .map { $0.key.hashValue ^ $0.value.hashValue }
            .reduce(0, ^)
    }

    public static func == (lhs: DecodeError, rhs: DecodeError) -> Bool {
        return lhs.errors == rhs.errors
    }
}

extension DecodeError {
    internal static func + (lhs: DecodeError, rhs: DecodeError) -> DecodeError {
        var errors = lhs.errors
        for (path, error) in rhs.errors {
            errors[path] = error
        }
        return DecodeError(errors)
    }
}
