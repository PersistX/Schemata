import Foundation
import Result

public protocol RecordValue {
    associatedtype Encoded
    static var record: Value<Record, Encoded, Self> { get }
}

public protocol RecordObject {
    static var record: Schema<Self, Record> { get }
}

public struct Record: Format {
    public enum Error: Swift.Error {
    }
    
    public typealias Path = String
    
    public enum Field: FormatValue {
        public typealias Error = Record.Error
        
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
    
    public func decode<T>(_ path: Path, _ decode: Field.Decoder<T>) -> Result<T, DecodeError<Record>> {
        guard let value = self[path].flatMap({ decode($0).value }) else {
            fatalError()
        }
        return .success(value)
    }
}

extension Record.Error: Hashable {
    public var hashValue: Int {
        return 0
    }
    
    public static func == (lhs: Record.Error, rhs: Record.Error) -> Bool {
        return false
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

public func ~ <Object: RecordObject, Child: RecordObject>(
    lhs: KeyPath<Object, Set<Child>>,
    rhs: KeyPath<Child, Object>
) -> Schema<Object, Record>.Property<Set<Child>> {
    return Schema<Object, Record>.Property<Set<Child>>(
        keyPath: lhs,
        path: "(\(Child.self))",
        decode: { _ in .success([]) },
        encoded: Set<Child>.self,
        encode: { _ in .reference }
    )
}

public func ~ <Object: RecordObject, Value: RecordObject>(
    lhs: KeyPath<Object, Value>,
    rhs: Record.Path
) -> Schema<Object, Record>.Property<Value> {
    return Schema<Object, Record>.Property<Value>(
        keyPath: lhs,
        path: rhs,
        decode: { value in
            fatalError()
        },
        encoded: Value.self,
        encode: { _ in fatalError() }
    )
}

public func ~ <Object: RecordObject, Value: RecordValue>(
    lhs: KeyPath<Object, Value>,
    rhs: Record.Path
) -> Schema<Object, Record>.Property<Value> where Value.Encoded == String {
    return Schema<Object, Record>.Property<Value>(
        keyPath: lhs,
        path: rhs,
        decode: { value in
            if case let .string(value) = value {
                return Value.record.decode(value)
            } else {
                fatalError()
            }
        },
        encoded: Value.Encoded.self,
        encode: { Record.Value.string(Value.record.encode($0)) }
    )
}

extension String: RecordValue {
    public static let record = Value<Record, String, String>()
}
