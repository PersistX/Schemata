import Foundation
import Result

private extension Format {
    func decode<Model, T>(
        _ property: Schema<Model, Self>.Property<T>
    ) -> Result<T, DecodeError<Self>> {
        return decode(property.path, property.value.decode)
    }
    
    mutating func encode<Model, T>(
        _ model: Model,
        for property: Schema<Model, Self>.Property<T>
    ) {
        self[property.path] = property.value.encode(model[keyPath: property.keyPath])
    }
}

private extension DecodeError {
    init(_ errors: DecodeError?...) {
        self = errors
            .flatMap { $0 }
            .reduce(DecodeError([:]), +)
    }
}

public struct Schema<Model, Format: Schemata.Format> {
    public struct Property<T> {
        public let keyPath: KeyPath<Model, T>
        public let path: Format.Path
        public let value: Value<T, Format>
        
        public init(keyPath: KeyPath<Model, T>, path: Format.Path, value: Value<T, Format>) {
            self.keyPath = keyPath
            self.path = path
            self.value = value
        }
    }
    
    public typealias Decoded = Result<Model, DecodeError<Format>>
    public typealias Decoder = (Format) -> Decoded
    public typealias Encoder = (Model) -> Format
    
    public let decode: Decoder
    public let encode: Encoder
    
    public init(decode: @escaping Decoder, encode: @escaping Encoder) {
        self.decode = decode
        self.encode = encode
    }
}

extension Schema {
    public init<A, B>(
        _ f: @escaping (A, B) -> Model,
        _ a: Property<A>,
        _ b: Property<B>
    ) {
        self.init(
            decode: { format -> Decoded in
                let a = format.decode(a)
                let b = format.decode(b)
                if let a = a.value,
                   let b = b.value {
                    return .success(f(a, b))
                } else {
                    return .failure(DecodeError(
                        a.error,
                        b.error
                    ))
                }
            },
            encode: { value -> Format in
                var format = Format()
                format.encode(value, for: a)
                format.encode(value, for: b)
                return format
            }
        )
    }
    
    public init<A, B, C>(
        _ f: @escaping (A, B, C) -> Model,
        _ a: Property<A>,
        _ b: Property<B>,
        _ c: Property<C>
    ) {
        self.init(
            decode: { format -> Decoded in
                let a = format.decode(a)
                let b = format.decode(b)
                let c = format.decode(c)
                if let a = a.value,
                   let b = b.value,
                   let c = c.value {
                    return .success(f(a, b, c))
                } else {
                    return .failure(DecodeError(
                        a.error,
                        b.error,
                        c.error
                    ))
                }
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
