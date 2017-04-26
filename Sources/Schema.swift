import Foundation
import Result
import Runes

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
    
    init()
    subscript(_ path: Path) -> Self? { get set }
}

// Move inside Schema once nested generics are fixed
public struct Property<Value, Format: Schemata.Format, T: KeyPathCompliant> {
    public let path: Format.Path
    public let keyPath: KeyPath<Value, T>
    public let schema: Schema<T, Format>
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
    
    public init<A: KeyPathCompliant, B: KeyPathCompliant>(
        _ f: @escaping (A, B) -> Value,
        _ a: Property<A>,
        _ b: Property<B>
    ) {
        self.init(
            decode: { format -> Decoded in
                if let a = format[a.path].flatMap({ a.schema.decode($0).value }),
                  let b = format[b.path].flatMap({ b.schema.decode($0).value }) {
                    return .success(f(a, b))
                }
                return Decoded.failure(NSError(domain: "foo", code: 1, userInfo: nil))
            },
            encode: { value -> Format in
                var format = Format()
                format[a.path] = a.schema.encode(value.value(of: a.keyPath))
                format[b.path] = b.schema.encode(value.value(of: b.keyPath))
                return format
            }
        )
    }
}

extension Schema {
    public func bimap<NewValue>(
        decode: @escaping (Value) -> NewValue,
        encode: @escaping (NewValue) -> Value
    ) -> Schema<NewValue, Format> {
        return Schema<NewValue, Format>(
            decode: { self.decode($0).map(decode) },
            encode: { self.encode(encode($0)) }
        )
    }
}
