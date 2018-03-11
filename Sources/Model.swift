import Foundation
import Result

public protocol AnyModelValue {
    static var anyValue: AnyValue { get }
}

public protocol ModelValue: AnyModelValue, Hashable {
    associatedtype Encoded
    static var value: Value<Encoded, Self> { get }
}

extension ModelValue where Encoded == Date {
    public static var anyValue: AnyValue {
        return AnyValue(value)
    }
}

extension ModelValue where Encoded == Double {
    public static var anyValue: AnyValue {
        return AnyValue(value)
    }
}

extension ModelValue where Encoded == Int {
    public static var anyValue: AnyValue {
        return AnyValue(value)
    }
}

extension ModelValue where Encoded == String {
    public static var anyValue: AnyValue {
        return AnyValue(value)
    }
}

extension ModelValue where Encoded == None {
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

public protocol ModelProjection: Hashable {
    associatedtype Model: Schemata.Model
    static var projection: Projection<Model, Self> { get }
}

extension Date: ModelValue {
    public static let value = Value<Date, Date>()
}

extension Double: ModelValue {
    public static let value = Value<Double, Double>()
}

extension Int: ModelValue {
    public static let value = Value<Int, Int>()
}

#if swift(>=4.1)
    extension Optional: ModelValue where Wrapped: ModelValue {
        public typealias Encoded = Wrapped.Encoded?

        public static var value: Value<Wrapped.Encoded?, Wrapped?> {
            return Value(
                decode: { encoded in
                    switch encoded {
                    case nil:
                        return .success(nil)
                    case let .some(value):
                        return Wrapped.value.decode(value).map(Optional.some)
                    }
                },
                encode: { $0.map(Wrapped.value.encode) }
            )
        }

        public static var anyValue: AnyValue {
            return AnyValue(
                encoded: Wrapped.anyValue.encoded,
                encode: { value in
                    // swiftlint:disab'le:next force_cast
                    (value as? Wrapped).map(Wrapped.anyValue.encode) ?? .null
                },
                decoded: Wrapped?.self,
                decode: { primitive -> Result<Any, ValueError> in
                    if primitive == .null {
                        return .success(Wrapped?.none as Any)
                    }
                    return Wrapped.anyValue
                        .decode(primitive)
                        // swiftlint:disable:next force_cast
                        .map { Optional($0 as! Wrapped) as Any }
                }
            )
        }

        public var hashValue: Int {
            switch self {
            case .none:
                return 0
            case let .some(value):
                return value.hashValue
            }
        }
    }
#endif

extension String: ModelValue {
    public static let value = Value<String, String>()
}

extension URL: ModelValue {
    public static let value = String.value.bimap(
        decode: { string in
            URL(string: string).map(Result.success)
                ?? .failure(.typeMismatch)
        },
        encode: { $0.absoluteString }
    )
}

extension UUID: ModelValue {
    public static let value = String.value.bimap(
        decode: { string in
            UUID(uuidString: string).map(Result.success)
                ?? .failure(.typeMismatch)
        },
        encode: { $0.uuidString }
    )
}
