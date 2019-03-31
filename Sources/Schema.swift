import Foundation

// swiftlint:disable large_tuple

private extension DecodeError {
    init(_ errors: DecodeError?...) {
        self = errors
            .compactMap { $0 }
            .reduce(DecodeError([:]), +)
    }
}

public struct Schema<Model: Schemata.Model>: Hashable {
    public let name: String
    public let properties: [PartialKeyPath<Model>: PartialProperty<Model>]

    fileprivate init(
        name: String = String(describing: Model.self),
        _ properties: PartialProperty<Model>...
    ) {
        self.name = name
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
            keyPath: partial.keyPath as! KeyPath<Model, Value>, // swiftlint:disable:this force_cast
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
        _: @escaping (A) -> Model,
        _ a: Property<Model, A>
    ) {
        self.init(PartialProperty(a))
    }

    public init<A>(
        _ initializer: Initializer<Model, A>,
        _ a: Property<Model, A>
    ) {
        self.init(name: initializer.name, PartialProperty(a))
    }

    public init<A, B>(
        _: @escaping (A, B) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>
    ) {
        self.init(PartialProperty(a), PartialProperty(b))
    }

    public init<A, B>(
        _ initializer: Initializer<Model, ((A, B))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b)
        )
    }

    public init<A, B, C>(
        _: @escaping (A, B, C) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>
    ) {
        self.init(PartialProperty(a), PartialProperty(b), PartialProperty(c))
    }

    public init<A, B, C>(
        _ initializer: Initializer<Model, ((A, B, C))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c)
        )
    }

    public init<A, B, C, D>(
        _: @escaping (A, B, C, D) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>
    ) {
        self.init(PartialProperty(a), PartialProperty(b), PartialProperty(c), PartialProperty(d))
    }

    public init<A, B, C, D>(
        _ initializer: Initializer<Model, ((A, B, C, D))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d)
        )
    }

    public init<A, B, C, D, E>(
        _: @escaping (A, B, C, D, E) -> Model,
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

    public init<A, B, C, D, E>(
        _ initializer: Initializer<Model, ((A, B, C, D, E))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e)
        )
    }

    public init<A, B, C, D, E, F>(
        _: @escaping (A, B, C, D, E, F) -> Model,
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

    public init<A, B, C, D, E, F>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f)
        )
    }

    public init<A, B, C, D, E, F, G>(
        _: @escaping (A, B, C, D, E, F, G) -> Model,
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

    public init<A, B, C, D, E, F, G>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>
    ) {
        self.init(
            name: initializer.name,
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

public struct AnySchema: Hashable {
    public var name: String
    public var properties: [AnyKeyPath: AnyProperty]

    public init<Model>(_ schema: Schema<Model>) {
        let properties = schema.properties.map { ($0.key as AnyKeyPath, AnyProperty($0.value)) }
        name = schema.name
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
                    queue.append(
                        (
                            keyPath: next.keyPath.appending(path: property.keyPath)!,
                            properties: next.properties + [property]
                        )
                    )
                }
            }
        }

        return []
    }
}
