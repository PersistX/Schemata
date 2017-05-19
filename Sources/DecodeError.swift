import Foundation

public struct DecodeError<Format: Schemata.Format>: Error {
    public var errors: [Format.Path: Format.Error]
    
    public init(_ errors: [Format.Path: Format.Error]) {
        self.errors = errors
    }
}

extension DecodeError: Hashable {
    public var hashValue: Int {
        #if swift(>=4)
            return errors
                .map { $0.key.hashValue ^ $0.value.hashValue }
                .reduce(0, ^)
        #else
            return errors
                .map { $0.hashValue ^ $1.hashValue }
                .reduce(0, ^)
        #endif
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
