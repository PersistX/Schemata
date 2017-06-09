import Foundation
import Result

private extension DecodeError {
    init(_ errors: DecodeError?...) {
        self = errors
            .flatMap { $0 }
            .reduce(DecodeError([:]), +)
    }
}

public struct Schema<Model> {
    public let properties: [PartialKeyPath<Model>: AnyProperty]
    
    fileprivate init(_ properties: AnyProperty...) {
        self.properties = Dictionary(uniqueKeysWithValues: properties.map { ($0.keyPath as! PartialKeyPath<Model>, $0) })
    }
    
    public func properties(for keyPath: AnyKeyPath) -> [AnyProperty] {
        var queue: [(keyPath: AnyKeyPath, properties: [AnyProperty])]
            = properties.values.map { ($0.keyPath, [$0]) }
        
        while let next = queue.first {
            queue.removeFirst()
            
            if next.keyPath == keyPath {
                return next.properties
            }
            
            if case let .toOne(type)? = next.properties.last?.type {
                for property in type.anySchema.properties.values {
                    queue.append((
                        keyPath: next.keyPath.appending(path: property.keyPath)!,
                        properties: next.properties + [property]
                    ))
                }
            }
        }
        
        return []
    }
    
    public func properties<Value>(for keyPath: KeyPath<Model, Value>) -> [AnyProperty] {
        return properties(for: keyPath as AnyKeyPath)
    }
}

extension Schema {
    public init<A, B>(
        _ f: @escaping (A, B) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>
    ) {
        self.init(AnyProperty(a), AnyProperty(b))
    }
    
    public init<A, B, C>(
        _ f: @escaping (A, B, C) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>
    ) {
        self.init(AnyProperty(a), AnyProperty(b), AnyProperty(c))
    }
}

extension Schema: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(Model.self) {\n"
            + properties.values.map { "\t" + $0.debugDescription }.sorted().joined(separator: "\n")
            + "\n}"
    }
}

public struct AnySchema {
    public let properties: [AnyKeyPath: AnyProperty]
    
    public init<Model>(_ schema: Schema<Model>) {
        self.properties = Dictionary(uniqueKeysWithValues: schema.properties.map { ($0.key as AnyKeyPath, $0.value)})
    }
}
