import Foundation
import Result

public protocol AnyModelValue {
    static var anyValue: AnyValue { get }
}

public protocol ModelValue: AnyModelValue, Equatable {
    associatedtype Encoded
    static var value: Value<Encoded, Self> { get }
}

extension ModelValue {
    public static var anyValue: AnyValue {
        return AnyValue(value)
    }
}

public protocol AnyModel {
    static var anySchema: AnySchema { get }
}

public protocol Model: AnyModel {
    static var schema: Schema<Self> { get }
}

extension Model {
    public static var anySchema: AnySchema {
        return AnySchema(schema)
    }
}

public protocol ModelProjection {
    associatedtype Model: Schemata.Model
    static var projection: Projection<Model, Self> { get }
}

extension Int: ModelValue {
    public static let value = Value<Int, Int>()
}

extension String: ModelValue {
    public static let value = Value<String, String>()
}

extension UUID: ModelValue {
    public static let value = String.value.bimap(
        decode: { string in
            return UUID(uuidString: string).map(Result.success)
                ?? .failure(.typeMismatch)
        },
        encode: { $0.uuidString }
    )
}
