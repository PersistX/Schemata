import Foundation

public enum PropertyType {
    case toMany(AnyModel.Type)
    case toOne(AnyModel.Type, nullable: Bool)
    case value(AnyModelValue.Type, nullable: Bool)
}

extension PropertyType: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .toMany(anyModel), let .toOne(anyModel, _):
            ObjectIdentifier(anyModel).hash(into: &hasher)

        case let .value(anyModelValue, _):
            ObjectIdentifier(anyModelValue).hash(into: &hasher)
        }
    }

    public static func == (lhs: PropertyType, rhs: PropertyType) -> Bool {
        switch (lhs, rhs) {
        case let (.toMany(lhs), .toMany(rhs)):
            return lhs == rhs
        case let (.toOne(lhs, lhsNullable), .toOne(rhs, rhsNullable)):
            return lhs == rhs && lhsNullable == rhsNullable
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
        keyPath = property.keyPath
        path = property.path
        type = property.type
    }
}

extension PartialProperty: Hashable {
    public func hash(into hasher: inout Hasher) {
        keyPath.hash(into: &hasher)
    }

    public static func == (lhs: PartialProperty, rhs: PartialProperty) -> Bool {
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
    public var model: Any.Type
    public var keyPath: AnyKeyPath
    public var path: String
    public var type: PropertyType

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
    public func hash(into hasher: inout Hasher) {
        keyPath.hash(into: &hasher)
    }

    public static func == (lhs: AnyProperty, rhs: AnyProperty) -> Bool {
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
        case let .toOne(type, nullable):
            return "\(path): --->\(type)" + (nullable ? "?" : "")
        case let .value(type, nullable):
            let encoded = "\(type.anyValue.encoded)" + (nullable ? "?" : "")
            return "\(path): \(encoded) (\(type))"
        }
    }
}
