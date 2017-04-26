import Foundation
import Result

public protocol JSONMapped: KeyPathCompliant {
    static var json: Schema<Self, JSON> { get }
}

public enum JSON: Format {
    public enum Error: Swift.Error {
    }
    
    public struct Path {
        public var keys: [String]
        
        public init(_ keys: [String]) {
            self.keys = keys
        }
    }
    
    case object([String: JSON])
    case array([JSON])
    case string(String)
    case number(NSNumber)
    case bool(Bool)
    case null
    
    public init() {
        self = .object([:])
    }
    
    public subscript(_ path: Path) -> JSON? {
        get {
            if case let .object(value) = self {
                if path.keys.count == 1 {
                    return value[path.keys[0]]
                }
            }
            return nil
        }
        set {
            if case var .object(value) = self {
                if path.keys.count == 1 {
                    value[path.keys[0]] = newValue
                    self = .object(value)
                }
            }
        }
    }
}

extension JSON.Error: FormatError {
    public var hashValue: Int {
        return 0
    }
    
    public static func == (_ lhs: JSON.Error, _ rhs: JSON.Error) -> Bool {
        return false
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

extension JSON: Hashable {
    public var hashValue: Int {
        switch self {
        case let .object(value):
            return value.map { $0.hashValue ^ $1.hashValue }.reduce(0, ^)
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
    
    public static func == (lhs: JSON, rhs: JSON) -> Bool {
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

public func ~ <Model: KeyPathCompliant, Value: JSONMapped>(
    lhs: KeyPath<Model, Value>,
    rhs: JSON.Path
) -> Schema<Model, JSON>.Property<Value> {
    return Schema.Property(
        path: rhs,
        keyPath: lhs,
        schema: Value.json
    )
}

extension String: JSONMapped {
    public static let json = Schema<String, JSON>(
        decode: { json in
            if case let .string(value) = json {
                return .success(value)
            } else {
                fatalError()
            }
        },
        encode: { JSON.string($0) }
    )
    
    public func value<Leaf>(of keyPath: KeyPath<String, Leaf>) -> Leaf {
        fatalError()
    }
}

