import Foundation
import Result

private extension DecodeError {
    init(_ errors: DecodeError?...) {
        self = errors
            .flatMap { $0 }
            .reduce(DecodeError([:]), +)
    }
}

public struct Schema<Model: Schemata.Model> {
    public let name: String
    public let properties: [PartialKeyPath<Model>: PartialProperty<Model>]

    fileprivate init(_ properties: PartialProperty<Model>...) {
        self.name = String(describing: Model.self)
        self.properties = Dictionary(uniqueKeysWithValues: properties.map { ($0.keyPath, $0) })
    }

    public func properties(for keyPath: AnyKeyPath) -> [AnyProperty] {
        return AnySchema(self).properties(for: keyPath)
    }

    public func properties<Value>(for keyPath: KeyPath<Model, Value>) -> [AnyProperty] {
        return properties(for: keyPath as AnyKeyPath)
    }
}

extension Schema {
    public subscript<Value>(_ keyPath: KeyPath<Model, Value>) -> Property<Model, Value> {
        let partial = self[keyPath as PartialKeyPath<Model>]
        return Property<Model, Value>(
            keyPath: partial.keyPath as! KeyPath<Model, Value>,
            path: partial.path,
            type: partial.type
        )
    }

    public subscript<Value>(_ keyPath: KeyPath<Model, Value>) -> AnyProperty {
        return AnyProperty(self[keyPath as PartialKeyPath<Model>])
    }

    public subscript(_ keyPath: PartialKeyPath<Model>) -> PartialProperty<Model> {
        return properties[keyPath]!
    }
}

extension Schema {
    public init<A>(
        _ init: @escaping (A) -> Model,
        _ a: Property<Model, A>
    ) {
        self.init(PartialProperty(a))
    }

    public init<A, B>(
        _ init: @escaping (A, B) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>
    ) {
        self.init(PartialProperty(a), PartialProperty(b))
    }

    public init<A, B, C>(
        _ init: @escaping (A, B, C) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>
    ) {
        self.init(PartialProperty(a), PartialProperty(b), PartialProperty(c))
    }

    public init<A, B, C, D>(
        _ init: @escaping (A, B, C, D) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>
    ) {
        self.init(PartialProperty(a), PartialProperty(b), PartialProperty(c), PartialProperty(d))
    }

    public init<A, B, C, D, E>(
        _ init: @escaping (A, B, C, D, E) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e)
        )
    }

    public init<A, B, C, D, E, F>(
        _ init: @escaping (A, B, C, D, E, F) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f)
        )
    }

    public init<A, B, C, D, E, F, G>(
        _ init: @escaping (A, B, C, D, E, F, G) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g)
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

extension Schema: Hashable {
    public var hashValue: Int {
        return name.hashValue
            ^ properties
                .map { $0.key.hashValue ^ $0.value.hashValue }
                .reduce(0, ^)
    }

    public static func == (lhs: Schema, rhs: Schema) -> Bool {
        return lhs.name == rhs.name && lhs.properties == rhs.properties
    }
}

public struct AnySchema {
    public var name: String
    public var properties: [AnyKeyPath: AnyProperty]

    public init<Model>(_ schema: Schema<Model>) {
        let properties = schema.properties.map { ($0.key as AnyKeyPath, AnyProperty($0.value)) }
        self.name = schema.name
        self.properties = Dictionary(uniqueKeysWithValues: properties)
    }

    public func properties(for keyPath: AnyKeyPath) -> [AnyProperty] {
        var queue: [(keyPath: AnyKeyPath, properties: [AnyProperty])]
            = properties.values.map { ($0.keyPath, [$0]) }

        while let next = queue.first {
            queue.removeFirst()

            if next.keyPath == keyPath {
                return next.properties
            }

            if case let .toOne(type, _)? = next.properties.last?.type {
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
}

extension AnySchema: Hashable {
    public var hashValue: Int {
        return name.hashValue
            ^ properties
                .map { $0.key.hashValue ^ $0.value.hashValue }
                .reduce(0, ^)
    }

    public static func == (lhs: AnySchema, rhs: AnySchema) -> Bool {
        return lhs.name == rhs.name && lhs.properties == rhs.properties
    }
}
