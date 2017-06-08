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

public func ~ <Model: RecordModel, Child: RecordModel>(
    lhs: KeyPath<Model, Set<Child>>,
    rhs: KeyPath<Child, Model>
) -> Property<Record, Model, Set<Child>> {
    return Property<Record, Model, Set<Child>>(
        keyPath: lhs,
        path: "(\(Child.self))",
        decode: { _ in .success([]) },
        encoded: Set<Child>.self,
        encode: { _ in fatalError() },
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
        decode: { _ in fatalError()  },
        encoded: Value.self,
        encode: { _ in fatalError() },
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
        decode: { Value.value.decode($0 as! String) },
        encoded: Value.Encoded.self,
        encode: { Value.value.encode($0) as Any },
        schema: nil
    )
}

extension String: ModelValue {
    public static let value = Value<String, String>()
}
