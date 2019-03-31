import Foundation

public enum ValueError: Swift.Error, Hashable {
    case typeMismatch
}

public struct DecodeError: Error, Hashable {
    public var errors: [String: ValueError]

    public init(_ errors: [String: ValueError]) {
        self.errors = errors
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
