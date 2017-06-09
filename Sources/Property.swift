import Foundation
import Result

public struct Property<Model: Schemata.Model, Value> {
    public typealias Decoder = (Any) -> Result<Value, ValueError>
    public typealias Encoder = (Value) -> Any
    
    public let keyPath: KeyPath<Model, Value>
    public let path: String
    public let decode: Decoder
    public let encoded: Any.Type
    public let encode: Encoder
    
    // Since schemas can by cyclical, this needs to be lazy.
    fileprivate let makeSchema: (() -> Schema<Value>)?
    public var schema: Schema<Value>? {
        return makeSchema?()
    }
    
    public init(
        keyPath: KeyPath<Model, Value>,
        path: String,
        decode: @escaping Decoder,
        encoded: Any.Type,
        encode: @escaping Encoder,
        schema: (() -> Schema<Value>)?
    ) {
        self.keyPath = keyPath
        self.path = path
        self.decode = decode
        self.encoded = encoded
        self.encode = encode
        self.makeSchema = schema
    }
}

public struct AnyProperty {
    public let model: Any.Type
    public let keyPath: AnyKeyPath
    public let path: String
    public let decoded: Any.Type
    public let encoded: Any.Type
    
    // Since schemas can by cyclical, this needs to be lazy.
    fileprivate let makeSchema: (() -> AnySchema)?
    public var schema: AnySchema? {
        return makeSchema?()
    }
    
    public init<Model, Decoded>(_ property: Property<Model, Decoded>) {
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

extension AnyProperty: Hashable {
    public var hashValue: Int {
        return ObjectIdentifier(model).hashValue ^ keyPath.hashValue
    }
    
    public static func ==(lhs: AnyProperty, rhs: AnyProperty) -> Bool {
        return lhs.model == rhs.model
            && lhs.keyPath == rhs.keyPath
            && lhs.path == rhs.path
            && lhs.decoded == rhs.decoded
            && lhs.encoded == rhs.encoded
    }
}

extension AnyProperty: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(path): \(encoded) (\(decoded))"
    }
}
