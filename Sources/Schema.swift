import Foundation
import Result

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
        public let path: String
        public let decode: Decoder
        public let encoded: Any.Type
        public let encode: Encoder
        
        // Since schemas can by cyclical, this needs to be lazy.
        fileprivate let makeSchema: (() -> Schema<Format, Decoded>)?
        public var schema: Schema<Format, Decoded>? {
            return makeSchema?()
        }
        
        public init(
            keyPath: KeyPath<Model, Decoded>,
            path: String,
            decode: @escaping Decoder,
            encoded: Any.Type,
            encode: @escaping Encoder,
            schema: (() -> Schema<Format, Decoded>)?
        ) {
            self.keyPath = keyPath
            self.path = path
            self.decode = decode
            self.encoded = encoded
            self.encode = encode
            self.makeSchema = schema
        }
    }
    
    public typealias Decoded = Result<Model, DecodeError<Format>>
    public typealias Decoder = (Format) -> Decoded
    public typealias Encoder = (Model) -> Format
    
    public let properties: [String: AnySchema<Format>.Property]
    
    public init(properties: [AnySchema<Format>.Property]) {
        self.properties = Dictionary(uniqueKeysWithValues: properties.map { ($0.path, $0) })
    }
    
    public func properties(for keyPath: AnyKeyPath) -> [AnySchema<Format>.Property] {
        var queue: [(keyPath: AnyKeyPath, properties: [AnySchema<Format>.Property])]
            = properties.values.map { ($0.keyPath, [$0]) }
        
        while let next = queue.first {
            queue.removeFirst()
            
            if next.keyPath == keyPath {
                return next.properties
            }
            
            if let schema = next.properties.last?.schema {
                for property in schema.properties.values {
                    queue.append((
                        keyPath: next.keyPath.appending(path: property.keyPath)!,
                        properties: next.properties + [property]
                    ))
                }
            }
        }
        
        return []
    }
    
    public func properties<Value>(for keyPath: KeyPath<Model, Value>) -> [AnySchema<Format>.Property] {
        return properties(for: keyPath as AnyKeyPath)
    }
}

extension Schema {
    public init<A, B>(
        _ f: @escaping (A, B) -> Model,
        _ a: Property<A>,
        _ b: Property<B>
    ) {
        self.init(
            properties: [AnySchema.Property(a), AnySchema.Property(b)]
        )
    }
    
    public init<A, B, C>(
        _ f: @escaping (A, B, C) -> Model,
        _ a: Property<A>,
        _ b: Property<B>,
        _ c: Property<C>
    ) {
        self.init(
            properties: [AnySchema.Property(a), AnySchema.Property(b), AnySchema.Property(c)]
        )
    }
}

extension Schema: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(Model.self) {\n"
            + properties.values.map { "\t" + $0.debugDescription }.sorted().joined(separator: "\n")
            + "\n}"
    }
}

public struct AnySchema<Format: Schemata.Format> {
    public struct Property {
        public let model: Any.Type
        public let keyPath: AnyKeyPath
        public let path: String
        public let decoded: Any.Type
        public let encoded: Any.Type
        
        // Since schemas can by cyclical, this needs to be lazy.
        fileprivate let makeSchema: (() -> AnySchema<Format>)?
        public var schema: AnySchema<Format>? {
            return makeSchema?()
        }
        
        public init<Model, Decoded>(_ property: Schema<Format, Model>.Property<Decoded>) {
            model = Model.self
            keyPath = property.keyPath as AnyKeyPath
            path = property.path
            decoded = Decoded.self
            encoded = property.encoded
            
            if let makeSchema = property.makeSchema {
                self.makeSchema = { AnySchema(makeSchema()) }
            } else {
                self.makeSchema = nil
            }
        }
    }
    
    public let properties: [String: Property]
    
    public init<Model>(_ schema: Schema<Format, Model>) {
        self.properties = schema.properties
    }
}

extension AnySchema.Property: Hashable {
    public var hashValue: Int {
        return ObjectIdentifier(model).hashValue ^ keyPath.hashValue
    }
    
    public static func ==(lhs: AnySchema<Format>.Property, rhs: AnySchema<Format>.Property) -> Bool {
        return lhs.model == rhs.model
            && lhs.keyPath == rhs.keyPath
            && lhs.path == rhs.path
            && lhs.decoded == rhs.decoded
            && lhs.encoded == rhs.encoded
    }
}

extension AnySchema.Property: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(path): \(encoded) (\(decoded))"
    }
}
