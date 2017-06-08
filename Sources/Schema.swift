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
    public typealias Decoded = Result<Model, DecodeError>
    public typealias Decoder = (Format) -> Decoded
    public typealias Encoder = (Model) -> Format
    
    public let properties: [String: AnyProperty<Format>]
    
    public init(properties: [AnyProperty<Format>]) {
        self.properties = Dictionary(uniqueKeysWithValues: properties.map { ($0.path, $0) })
    }
    
    public func properties(for keyPath: AnyKeyPath) -> [AnyProperty<Format>] {
        var queue: [(keyPath: AnyKeyPath, properties: [AnyProperty<Format>])]
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
    
    public func properties<Value>(for keyPath: KeyPath<Model, Value>) -> [AnyProperty<Format>] {
        return properties(for: keyPath as AnyKeyPath)
    }
}

extension Schema {
    public init<A, B>(
        _ f: @escaping (A, B) -> Model,
        _ a: Property<Format, Model, A>,
        _ b: Property<Format, Model, B>
    ) {
        self.init(
            properties: [AnyProperty(a), AnyProperty(b)]
        )
    }
    
    public init<A, B, C>(
        _ f: @escaping (A, B, C) -> Model,
        _ a: Property<Format, Model, A>,
        _ b: Property<Format, Model, B>,
        _ c: Property<Format, Model, C>
    ) {
        self.init(
            properties: [AnyProperty(a), AnyProperty(b), AnyProperty(c)]
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
    public let properties: [String: AnyProperty<Format>]
    
    public init<Model>(_ schema: Schema<Format, Model>) {
        self.properties = schema.properties
    }
}
