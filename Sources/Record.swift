import Foundation
import Result

public protocol ModelValue: Equatable {
    associatedtype Encoded
    static var value: Value<Encoded, Self> { get }
}

public protocol Model {
    static var schema: Schema<Self> { get }
}

public protocol ModelProjection {
    associatedtype Model: Model
    static var projection: Projection<Model, Self> { get }
}

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

extension String: ModelValue {
    public static let value = Value<String, String>()
}
