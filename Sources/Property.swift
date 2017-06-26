import Foundation
import Result

public enum PropertyType {
    case toMany(AnyModel.Type)
    case toOne(AnyModel.Type)
    case value(AnyModelValue.Type, nullable: Bool)
}

extension PropertyType: Hashable {
    public var hashValue: Int {
        switch self {
        case let .toMany(anyModel), let .toOne(anyModel):
            return ObjectIdentifier(anyModel).hashValue
        case let .value(anyModelValue, _):
            return ObjectIdentifier(anyModelValue).hashValue
        }
    }
    
    public static func ==(lhs: PropertyType, rhs: PropertyType) -> Bool {
        switch (lhs, rhs) {
        case let (.toMany(lhs), .toMany(rhs)),
             let (.toOne(lhs), .toOne(rhs)):
            return lhs == rhs
        case let (.value(lhs, lhsNullable), .value(rhs, rhsNullable)):
            return lhs == rhs && lhsNullable == rhsNullable
        default:
            return false
        }
    }
}

public struct Property<Model: Schemata.Model, Value> {
    public let keyPath: KeyPath<Model, Value>
    public let path: String
    public let type: PropertyType
    
    internal init(
        keyPath: KeyPath<Model, Value>,
        path: String,
        type: PropertyType
    ) {
        self.keyPath = keyPath
        self.path = path
        self.type = type
    }
}

public struct PartialProperty<Model: Schemata.Model> {
    public let keyPath: PartialKeyPath<Model>
    public let path: String
    public let type: PropertyType
    
    public init<Decoded>(_ property: Property<Model, Decoded>) {
        self.keyPath = property.keyPath
        self.path = property.path
        self.type = property.type
    }
}

extension PartialProperty: Hashable {
    public var hashValue: Int {
        return keyPath.hashValue
    }
    
    public static func ==(lhs: PartialProperty, rhs: PartialProperty) -> Bool {
        return lhs.keyPath == rhs.keyPath
            && lhs.path == rhs.path
            && lhs.type == rhs.type
    }
}

extension PartialProperty: CustomDebugStringConvertible {
    public var debugDescription: String {
        return AnyProperty(self).debugDescription
    }
}

public struct AnyProperty {
    public let model: Any.Type
    public let keyPath: AnyKeyPath
    public let path: String
    public let type: PropertyType
    
    public init<Model>(_ property: PartialProperty<Model>) {
        model = Model.self
        keyPath = property.keyPath
        path = property.path
        type = property.type
    }
    
    public init<Model, Decoded>(_ property: Property<Model, Decoded>) {
        model = Model.self
        keyPath = property.keyPath
        path = property.path
        type = property.type
    }
}

extension AnyProperty: Hashable {
    public var hashValue: Int {
        return keyPath.hashValue
    }
    
    public static func ==(lhs: AnyProperty, rhs: AnyProperty) -> Bool {
        return lhs.model == rhs.model
            && lhs.keyPath == rhs.keyPath
            && lhs.path == rhs.path
            && lhs.type == rhs.type
    }
}

extension AnyProperty: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch type {
        case let .toMany(type):
            return "\(path): -->>\(type)"
        case let .toOne(type):
            return "\(path): --->\(type)"
        case let .value(type, nullable):
            let encoded = "\(type.anyValue.encoded)" + (nullable ? "?" : "")
            return "\(path): \(encoded) (\(type))"
        }
    }
}
