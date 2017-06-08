import Foundation
import Result

public struct Record: Format {
    public enum Field {
        case string(String)
    }
    
    public var fields: [String: Field]
    
    public init(_ fields: [String: Field]) {
        self.fields = fields
    }
    
    public init() {
        self.init([:])
    }
    
    public subscript(_ path: String) -> String? {
        get {
            return fields[path].flatMap { field in
                if case let .string(value) = field {
                    return value
                } else {
                    return nil
                }
            }
        }
        set {
            fields[path] = newValue.map(Field.string)
        }
    }
}

extension Record.Field: Hashable {
    public var hashValue: Int {
        switch self {
        case let .string(value):
            return value.hashValue
        }
    }
    
    public static func == (lhs: Record.Field, rhs: Record.Field) -> Bool {
        switch (lhs, rhs) {
        case let (.string(lhs), .string(rhs)):
            return lhs == rhs
        }
    }
}

extension Record: Hashable {
    public var hashValue: Int {
        return fields
            .map { $0.key.hashValue ^ $0.value.hashValue }
            .reduce(0, ^)
    }
    
    public static func == (lhs: Record, rhs: Record) -> Bool {
        return lhs.fields == rhs.fields
    }
}
