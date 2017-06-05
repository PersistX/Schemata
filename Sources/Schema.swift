import Foundation
import Result

private extension Format {
    func decode<Model, T>(
        _ property: Schema<Self, Model>.Property<T>
    ) -> Result<T, DecodeError<Self>> {
        return decode(property.path, property.decode)
    }
    
    mutating func encode<Model, T>(
        _ model: Model,
        for property: Schema<Self, Model>.Property<T>
    ) {
        self[property.path] = property.encode(model[keyPath: property.keyPath])
    }
}

private extension DecodeError {
    init(_ errors: DecodeError?...) {
        self = errors
            .flatMap { $0 }
            .reduce(DecodeError([:]), +)
    }
}

public struct Schema<Format: Schemata.Format, Model> {
    public struct Property<Decoded> {
        public typealias Decoder = Format.Value.Decoder<Decoded>
        public typealias Encoder = Format.Value.Encoder<Decoded>
        
        public let keyPath: KeyPath<Model, Decoded>
        public let path: Format.Path
        public let decode: Decoder
        public let encoded: Any.Type
        public let encode: Encoder
        
        public init(
            keyPath: KeyPath<Model, Decoded>,
            path: Format.Path,
            decode: @escaping Decoder,
            encoded: Any.Type,
            encode: @escaping Encoder
        ) {
            self.keyPath = keyPath
            self.path = path
            self.decode = decode
            self.encoded = encoded
            self.encode = encode
        }
    }
    
    public struct AnyProperty {
        public let keyPath: PartialKeyPath<Model>
        public let path: Format.Path
        public let decoded: Any.Type
        public let encoded: Any.Type
        
        public init<Decoded>(_ property: Property<Decoded>) {
            keyPath = property.keyPath as PartialKeyPath<Model>
            path = property.path
            decoded = Decoded.self
            encoded = property.encoded
        }
    }
    
    public typealias Decoded = Result<Model, DecodeError<Format>>
    public typealias Decoder = (Format) -> Decoded
    public typealias Encoder = (Model) -> Format
    
    public let decode: Decoder
    public let encode: Encoder
    public let properties: [Format.Path: AnyProperty]
    
    public init(decode: @escaping Decoder, encode: @escaping Encoder, properties: [AnyProperty]) {
        self.decode = decode
        self.encode = encode
        self.properties = Dictionary(uniqueKeysWithValues: properties.map { ($0.path, $0) })
    }
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
            },
            properties: [AnyProperty(a), AnyProperty(b)]
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
            },
            properties: [AnyProperty(a), AnyProperty(b), AnyProperty(c)]
        )
    }
}

extension Schema.AnyProperty: Hashable {
    public var hashValue: Int {
        return keyPath.hashValue
    }

    public static func ==(lhs: Schema.AnyProperty, rhs: Schema.AnyProperty) -> Bool {
        return lhs.keyPath == rhs.keyPath
            && lhs.path == rhs.path
            && lhs.decoded == rhs.decoded
            && lhs.encoded == rhs.encoded
    }
}

extension Schema.AnyProperty: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(path): \(encoded) (\(decoded))"
    }
}

extension Schema: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(Model.self) {\n"
            + properties.values.map { "\t" + $0.debugDescription }.sorted().joined(separator: "\n")
            + "\n}"
    }
}
