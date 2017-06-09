import Foundation
import Result

public enum PropertyType {
    case toMany(AnyModel.Type)
    case toOne(AnyModel.Type)
    case value(AnyModelValue.Type)
}

extension PropertyType: Hashable {
    public var hashValue: Int {
        switch self {
        case let .toMany(anyModel), let .toOne(anyModel):
            return ObjectIdentifier(anyModel).hashValue
        case let .value(anyModelValue):
            return ObjectIdentifier(anyModelValue).hashValue
        }
    }
    
    public static func ==(lhs: PropertyType, rhs: PropertyType) -> Bool {
        switch (lhs, rhs) {
        case let (.toMany(lhs), .toMany(rhs)),
             let (.toOne(lhs), .toOne(rhs)):
            return lhs == rhs
        case let (.value(lhs), .value(rhs)):
            return lhs == rhs
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

public struct AnyProperty {
    public let model: Any.Type
    public let keyPath: AnyKeyPath
    public let path: String
    public let type: PropertyType
    
    public init<Model, Decoded>(_ property: Property<Model, Decoded>) {
        model = Model.self
        keyPath = property.keyPath as AnyKeyPath
        path = property.path
        type = property.type
    }
}

extension AnyProperty: Hashable {
    public var hashValue: Int {
        return ObjectIdentifier(model).hashValue ^ keyPath.hashValue
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
        case let .value(type):
            return "\(path): \(type.anyValue.encoded) (\(type))"
        }
    }
}
