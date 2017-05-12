import Foundation
import Result

public protocol JSONValue {
    static var json: Value<Self, JSON> { get }
}

public protocol JSONObject: KeyPathCompliant {
    static var json: Schema<Self, JSON> { get }
}

public struct JSON: Format {
    public enum Error: Swift.Error {
        case typeMismatch(expected: Any.Type, actual: JSON.Value)
        case missingKey
        case invalidValue(JSON.Value, description: String?)
    }
    
    public struct Path {
        public var keys: [String]
        
        public init(_ keys: [String]) {
            self.keys = keys
        }
    }
    
    public enum Value: FormatValue {
        public typealias Error = DecodeError<JSON>
        
        case object(JSON)
        case array([Value])
        case string(String)
        case number(NSNumber)
        case bool(Bool)
        case null
    }
    
    public var properties: [String: Value]
    
    public init(_ properties: [String: Value]) {
        self.properties = properties
    }
    
    public init() {
        self.init([:])
    }
    
    public subscript(_ path: Path) -> Value? {
        get {
            if path.keys.count == 1 {
                return properties[path.keys[0]]
            }
            return nil
        }
        set {
            if path.keys.count == 1 {
                properties[path.keys[0]] = newValue
            }
        }
    }
    
    public func decode<T>(_ path: Path, _ decode: Schemata.Value<T, JSON>.Decoder) -> T? {
        return self[path].flatMap { decode($0).value }
    }
}

extension JSON.Error: FormatError {
    public var hashValue: Int {
        switch self {
        case let .typeMismatch(expected, actual):
            return 0 ^ ObjectIdentifier(expected).hashValue ^ actual.hashValue
        case .missingKey:
            return 1
        case let .invalidValue(value, description):
            return 2 ^ value.hashValue ^ (description?.hashValue ?? 0)
        }
    }
    
    public static func == (_ lhs: JSON.Error, _ rhs: JSON.Error) -> Bool {
        switch (lhs, rhs) {
        case let (.typeMismatch(lhsExpected, lhsActual), .typeMismatch(rhsExpected, rhsActual)):
            return lhsExpected == rhsExpected && lhsActual == rhsActual
        case (.missingKey, .missingKey):
            return true
        case let (.invalidValue(lhsValue, lhsDescription), .invalidValue(rhsValue, rhsDescription)):
            return lhsValue == rhsValue && lhsDescription == rhsDescription
        default:
            return false
        }
    }
}

extension JSON.Path: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init([value])
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init([value])
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init([value])
    }
}

extension JSON.Path: Hashable {
    public var hashValue: Int {
        return keys.map { $0.hashValue }.reduce(0, ^)
    }
    
    public static func == (lhs: JSON.Path, rhs: JSON.Path) -> Bool {
        return lhs.keys == rhs.keys
    }
}

extension JSON.Value: Hashable {
    public var hashValue: Int {
        switch self {
        case let .object(value):
            return value.hashValue
        case let .array(value):
            return value.map { $0.hashValue }.reduce(0, ^)
        case let .string(value):
            return value.hashValue
        case let .number(value):
            return value.hashValue
        case let .bool(value):
            return value.hashValue
        case .null:
            return 0
        }
    }
    
    public static func == (lhs: JSON.Value, rhs: JSON.Value) -> Bool {
        switch (lhs, rhs) {
        case let (.string(lhs), .string(rhs)):
            return lhs == rhs
        case let (.number(lhs), .number(rhs)):
            return lhs == rhs
        case let (.bool(lhs), .bool(rhs)):
            return lhs == rhs
        case let (.array(lhs), .array(rhs)):
            return lhs == rhs
        case let (.object(lhs), .object(rhs)):
            return lhs == rhs
        case (.null, .null):
            return true
        default:
            return false
        }
    }
}

extension JSON: Hashable {
    public var hashValue: Int {
        return properties
            .map { $0.hashValue ^ $1.hashValue }
            .reduce(0, ^)
    }
    
    public static func == (lhs: JSON, rhs: JSON) -> Bool {
        return lhs.properties == rhs.properties
    }
}

public func ~ <Root: JSONObject, Object: JSONObject>(
    lhs: KeyPath<Root, Object>,
    rhs: JSON.Path
) -> Schema<Root, JSON>.Property<Object> {
    return Property<Root, JSON, Object>(
        keyPath: lhs,
        path: rhs,
        value: Value(
            decode: { json in
                if case let .object(json) = json {
                    return Object.json.decode(json)
                } else {
                    fatalError()
                }
            },
            encode:{ value in .object(Object.json.encode(value)) }
        )
    )
}

public func ~ <Object: JSONObject, Value: JSONValue>(
    lhs: KeyPath<Object, Value>,
    rhs: JSON.Path
) -> Schema<Object, JSON>.Property<Value> {
    return Property<Object, JSON, Value>(
        keyPath: lhs,
        path: rhs,
        value: Value.json
    )
}

extension String: JSONValue {
    public static let json = Value<String, JSON>(
        decode: { jsonValue in
            if case let .string(value) = jsonValue {
                return .success(value)
            } else {
                fatalError()
            }
        },
        encode: JSON.Value.string
    )
}
