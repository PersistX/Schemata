import Foundation

public struct DecodeError<Format: Schemata.Format>: FormatError {
    public var errors: [Format.Path: Format.Error]
    
    public init(_ errors: [Format.Path: Format.Error]) {
        self.errors = errors
    }
    
    public var hashValue: Int {
        return errors
            .map { $0.hashValue ^ $1.hashValue }
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
