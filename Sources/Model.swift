import Foundation

public protocol ModelValue: Equatable {
    associatedtype Encoded
    static var value: Value<Encoded, Self> { get }
}

public protocol Model {
    static var schema: Schema<Self> { get }
}

public protocol ModelProjection {
    associatedtype Model: Schemata.Model
    static var projection: Projection<Model, Self> { get }
}

extension String: ModelValue {
    public static let value = Value<String, String>()
}
