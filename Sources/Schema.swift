import Foundation
import Result

public protocol FormatError: Error, Hashable {
}

public protocol FormatValue: Hashable {
    typealias Decoded<T> = Result<T, Error>
    typealias Decoder<T> = (Self) -> Decoded<T>
    typealias Encoder<T> = (T) -> Self
    
    associatedtype Error: FormatError
}

precedencegroup SchemataDecodePrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
    lowerThan: NilCoalescingPrecedence
}

infix operator ~ : SchemataDecodePrecedence

public protocol Format {
    associatedtype Error: FormatError
    associatedtype Path: Hashable
    associatedtype Value: FormatValue
    
    init()
    subscript(_ path: Path) -> Value? { get set }
    
    func decode<T>(_ path: Path, _ decode: Schemata.Value<T, Self>.Decoder) -> T?
}

private extension Format {
    func decode<Object: KeyPathCompliant, T: KeyPathCompliant>(
        _ property: Property<Object, Self, T>
    ) -> T? {
        return decode(property.path, property.value.decode)
    }
    
    mutating func encode<Object: KeyPathCompliant, T: KeyPathCompliant>(
        _ object: Object,
        for property: Property<Object, Self, T>
    ) {
        self[property.path] = property.value.encode(object.value(of: property.keyPath))
    }
}

// Move inside Schema once nested generics are fixed
public struct Property<Object, Format: Schemata.Format, T: KeyPathCompliant> {
    public let keyPath: KeyPath<Object, T>
    public let path: Format.Path
    public let value: Value<T, Format>
    
    public init(keyPath: KeyPath<Object, T>, path: Format.Path, value: Value<T, Format>) {
        self.keyPath = keyPath
        self.path = path
        self.value = value
    }
}

public struct Value<T, Format: Schemata.Format> {
    public typealias Decoder = Format.Value.Decoder<T>
    public typealias Encoder = Format.Value.Encoder<T>
    
    public let decode: Decoder
    public let encode: Encoder
    
    public init(decode: @escaping Decoder, encode: @escaping Encoder) {
        self.decode = decode
        self.encode = encode
    }
}

public struct Schema<Value: KeyPathCompliant, Format: Schemata.Format> {
    public typealias Property<T: KeyPathCompliant> = Schemata.Property<Value, Format, T>
    
    public typealias Decoded = Result<Value, DecodeError<Format>>
    public typealias Decoder = (Format) -> Decoded
    public typealias Encoder = (Value) -> Format
    
    public let decode: Decoder
    public let encode: Encoder
    
    public init(decode: @escaping Decoder, encode: @escaping Encoder) {
        self.decode = decode
        self.encode = encode
    }
}

extension Schema {
    public init<A: KeyPathCompliant, B: KeyPathCompliant>(
        _ f: @escaping (A, B) -> Value,
        _ a: Property<A>,
        _ b: Property<B>
    ) {
        self.init(
            decode: { format -> Decoded in
                let a = format.decode(a)
                let b = format.decode(b)
                if let a = a, let b = b {
                    return .success(f(a, b))
                }
                fatalError()
            },
            encode: { value -> Format in
                var format = Format()
                format.encode(value, for: a)
                format.encode(value, for: b)
                return format
            }
        )
    }
    
    public init<A: KeyPathCompliant, B: KeyPathCompliant, C: KeyPathCompliant>(
        _ f: @escaping (A, B, C) -> Value,
        _ a: Property<A>,
        _ b: Property<B>,
        _ c: Property<C>
    ) {
        self.init(
            decode: { format -> Decoded in
                let a = format.decode(a)
                let b = format.decode(b)
                let c = format.decode(c)
                if let a = a, let b = b, let c = c {
                    return .success(f(a, b, c))
                }
                fatalError()
            },
            encode: { value -> Format in
                var format = Format()
                format.encode(value, for: a)
                format.encode(value, for: b)
                format.encode(value, for: c)
                return format
            }
        )
    }
}

extension Value {
    public func bimap<NewValue>(
        decode: @escaping (T) -> NewValue,
        encode: @escaping (NewValue) -> T
    ) -> Value<NewValue, Format> {
        return Value<NewValue, Format>(
            decode: { self.decode($0).map(decode) },
            encode: { self.encode(encode($0)) }
        )
    }
}
