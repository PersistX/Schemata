import Foundation
import Result

public protocol ModelValue: Equatable {
    associatedtype Encoded
    static var value: Value<Encoded, Self> { get }
}

public protocol RecordModel {
    static var record: Schema<Record, Self> { get }
}

public protocol RecordProjection {
    associatedtype Model: RecordModel
    static var record: Projection<Model, Self> { get }
}

public struct Record: Format {
    public enum Field: FormatValue {
        case string(String)
        case reference
    }
    
    public var fields: [String: Field]
    
    public init(_ fields: [String: Field]) {
        self.fields = fields
    }
    
    public init() {
        self.init([:])
    }
    
    public subscript(_ field: String) -> Field? {
        get {
            return fields[field]
        }
        set {
            fields[field] = newValue
        }
    }
    
    public func decode<T>(_ path: String, _ decode: Field.Decoder<T>) -> Result<T, DecodeError> {
        guard let value = self[path].flatMap({ decode($0).value }) else {
            fatalError()
        }
        return .success(value)
    }
}

extension Record.Field: Hashable {
    public var hashValue: Int {
        switch self {
        case let .string(value):
            return value.hashValue
        case .reference:
            return 0
        }
    }
    
    public static func == (lhs: Record.Field, rhs: Record.Field) -> Bool {
        switch (lhs, rhs) {
        case let (.string(lhs), .string(rhs)):
            return lhs == rhs
        case (.reference, .reference):
            return true
        default:
            return false
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

public func ~ <Model: RecordModel, Child: RecordModel>(
    lhs: KeyPath<Model, Set<Child>>,
    rhs: KeyPath<Child, Model>
) -> Property<Record, Model, Set<Child>> {
    return Property<Record, Model, Set<Child>>(
        keyPath: lhs,
        path: "(\(Child.self))",
        decode: { _ in .success([]) },
        encoded: Set<Child>.self,
        encode: { _ in .reference },
        schema: nil
    )
}

public func ~ <Model: RecordModel, Value: RecordModel>(
    lhs: KeyPath<Model, Value>,
    rhs: String
) -> Property<Record, Model, Value> {
    return Property<Record, Model, Value>(
        keyPath: lhs,
        path: rhs,
        decode: { value in
            fatalError()
        },
        encoded: Value.self,
        encode: { _ in .reference },
        schema: { Value.record }
    )
}

public func ~ <Model: RecordModel, Value: ModelValue>(
    lhs: KeyPath<Model, Value>,
    rhs: String
) -> Property<Record, Model, Value> where Value.Encoded == String {
    return Property<Record, Model, Value>(
        keyPath: lhs,
        path: rhs,
        decode: { value in
            if case let .string(value) = value {
                return Value.value.decode(value)
            } else {
                fatalError()
            }
        },
        encoded: Value.Encoded.self,
        encode: { Record.Value.string(Value.value.encode($0)) },
        schema: nil
    )
}

extension String: ModelValue {
    public static let value = Value<String, String>()
}
