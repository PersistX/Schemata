import Foundation
import Result

public protocol FormatError: Error, Hashable {
}

precedencegroup SchemataDecodePrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
    lowerThan: NilCoalescingPrecedence
}

infix operator ~ : SchemataDecodePrecedence

public protocol Format {
    associatedtype Error: FormatError
    associatedtype Path
    associatedtype Value
    
    init()
    subscript(_ path: Path) -> Value? { get set }
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
    public typealias Decoded = Result<T, NSError>
    public typealias Decoder = (Format.Value) -> Decoded
    public typealias Encoder = (T) -> Format.Value
    
    public let decode: Decoder
    public let encode: Encoder
    
    public init(decode: @escaping Decoder, encode: @escaping Encoder) {
        self.decode = decode
        self.encode = encode
    }
}

public struct Schema<Value: KeyPathCompliant, Format: Schemata.Format> {
    public typealias Property<T: KeyPathCompliant> = Schemata.Property<Value, Format, T>
    
    public typealias Decoded = Result<Value, NSError>
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
                if let a = format[a.path].flatMap({ a.value.decode($0).value }),
                  let b = format[b.path].flatMap({ b.value.decode($0).value }) {
                    return .success(f(a, b))
                }
                return Decoded.failure(NSError(domain: "foo", code: 1, userInfo: nil))
            },
            encode: { value -> Format in
                var format = Format()
                format[a.path] = a.value.encode(value.value(of: a.keyPath))
                format[b.path] = b.value.encode(value.value(of: b.keyPath))
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
                if let a = format[a.path].flatMap({ a.value.decode($0).value }),
                    let b = format[b.path].flatMap({ b.value.decode($0).value }),
                    let c = format[c.path].flatMap({ c.value.decode($0).value }) {
                    return .success(f(a, b, c))
                }
                return Decoded.failure(NSError(domain: "foo", code: 1, userInfo: nil))
            },
            encode: { value -> Format in
                var format = Format()
                format[a.path] = a.value.encode(value.value(of: a.keyPath))
                format[b.path] = b.value.encode(value.value(of: b.keyPath))
                format[c.path] = c.value.encode(value.value(of: c.keyPath))
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
