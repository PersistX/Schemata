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

    public init<A, B, C, D, E, F, G, H>(
        _: @escaping (A, B, C, D, E, F, G, H) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h)
        )
    }

    public init<A, B, C, D, E, F, G, H>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h)
        )
    }

    public init<A, B, C, D, E, F, G, H, I>(
        _: @escaping (A, B, C, D, E, F, G, H, I) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i)
        )
    }

    public init<A, B, C, D, E, F, G, H, I>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H, I))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J>(
        _: @escaping (A, B, C, D, E, F, G, H, I, J) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H, I, J))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K>(
        _: @escaping (A, B, C, D, E, F, G, H, I, J, K) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H, I, J, K))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L>(
        _: @escaping (A, B, C, D, E, F, G, H, I, J, K, L) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H, I, J, K, L))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M>(
        _: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H, I, J, K, L, M))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
        _: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H, I, J, K, L, M, N))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
        _: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H, I, J, K, L, M, N, O))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
        _: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
        _: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
        _: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>,
        _ r: Property<Model, R>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q),
            PartialProperty(r)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>,
        _ r: Property<Model, R>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q),
            PartialProperty(r)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
        _: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>,
        _ r: Property<Model, R>,
        _ s: Property<Model, S>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q),
            PartialProperty(r),
            PartialProperty(s)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>,
        _ r: Property<Model, R>,
        _ s: Property<Model, S>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q),
            PartialProperty(r),
            PartialProperty(s)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
        _: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>,
        _ r: Property<Model, R>,
        _ s: Property<Model, S>,
        _ t: Property<Model, T>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q),
            PartialProperty(r),
            PartialProperty(s),
            PartialProperty(t)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>,
        _ r: Property<Model, R>,
        _ s: Property<Model, S>,
        _ t: Property<Model, T>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q),
            PartialProperty(r),
            PartialProperty(s),
            PartialProperty(t)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
        _: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>,
        _ r: Property<Model, R>,
        _ s: Property<Model, S>,
        _ t: Property<Model, T>,
        _ u: Property<Model, U>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q),
            PartialProperty(r),
            PartialProperty(s),
            PartialProperty(t),
            PartialProperty(u)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>,
        _ r: Property<Model, R>,
        _ s: Property<Model, S>,
        _ t: Property<Model, T>,
        _ u: Property<Model, U>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q),
            PartialProperty(r),
            PartialProperty(s),
            PartialProperty(t),
            PartialProperty(u)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>(
        _: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>,
        _ r: Property<Model, R>,
        _ s: Property<Model, S>,
        _ t: Property<Model, T>,
        _ u: Property<Model, U>,
        _ v: Property<Model, V>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q),
            PartialProperty(r),
            PartialProperty(s),
            PartialProperty(t),
            PartialProperty(u),
            PartialProperty(v)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>,
        _ r: Property<Model, R>,
        _ s: Property<Model, S>,
        _ t: Property<Model, T>,
        _ u: Property<Model, U>,
        _ v: Property<Model, V>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q),
            PartialProperty(r),
            PartialProperty(s),
            PartialProperty(t),
            PartialProperty(u),
            PartialProperty(v)
        )
    }
    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W>(
        _: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>,
        _ r: Property<Model, R>,
        _ s: Property<Model, S>,
        _ t: Property<Model, T>,
        _ u: Property<Model, U>,
        _ v: Property<Model, V>,
        _ w: Property<Model, W>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q),
            PartialProperty(r),
            PartialProperty(s),
            PartialProperty(t),
            PartialProperty(u),
            PartialProperty(v),
            PartialProperty(w)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>,
        _ r: Property<Model, R>,
        _ s: Property<Model, S>,
        _ t: Property<Model, T>,
        _ u: Property<Model, U>,
        _ v: Property<Model, V>,
        _ w: Property<Model, W>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q),
            PartialProperty(r),
            PartialProperty(s),
            PartialProperty(t),
            PartialProperty(u),
            PartialProperty(v),
            PartialProperty(w)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X>(
        _: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>,
        _ r: Property<Model, R>,
        _ s: Property<Model, S>,
        _ t: Property<Model, T>,
        _ u: Property<Model, U>,
        _ v: Property<Model, V>,
        _ w: Property<Model, W>,
        _ x: Property<Model, X>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q),
            PartialProperty(r),
            PartialProperty(s),
            PartialProperty(t),
            PartialProperty(u),
            PartialProperty(v),
            PartialProperty(w),
            PartialProperty(x)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>,
        _ r: Property<Model, R>,
        _ s: Property<Model, S>,
        _ t: Property<Model, T>,
        _ u: Property<Model, U>,
        _ v: Property<Model, V>,
        _ w: Property<Model, W>,
        _ x: Property<Model, X>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q),
            PartialProperty(r),
            PartialProperty(s),
            PartialProperty(t),
            PartialProperty(u),
            PartialProperty(v),
            PartialProperty(w),
            PartialProperty(x)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y>(
        _: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>,
        _ r: Property<Model, R>,
        _ s: Property<Model, S>,
        _ t: Property<Model, T>,
        _ u: Property<Model, U>,
        _ v: Property<Model, V>,
        _ w: Property<Model, W>,
        _ x: Property<Model, X>,
        _ y: Property<Model, Y>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q),
            PartialProperty(r),
            PartialProperty(s),
            PartialProperty(t),
            PartialProperty(u),
            PartialProperty(v),
            PartialProperty(w),
            PartialProperty(x),
            PartialProperty(y)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>,
        _ r: Property<Model, R>,
        _ s: Property<Model, S>,
        _ t: Property<Model, T>,
        _ u: Property<Model, U>,
        _ v: Property<Model, V>,
        _ w: Property<Model, W>,
        _ x: Property<Model, X>,
        _ y: Property<Model, Y>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q),
            PartialProperty(r),
            PartialProperty(s),
            PartialProperty(t),
            PartialProperty(u),
            PartialProperty(v),
            PartialProperty(w),
            PartialProperty(x),
            PartialProperty(y)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z>(
        _: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z) -> Model,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>,
        _ r: Property<Model, R>,
        _ s: Property<Model, S>,
        _ t: Property<Model, T>,
        _ u: Property<Model, U>,
        _ v: Property<Model, V>,
        _ w: Property<Model, W>,
        _ x: Property<Model, X>,
        _ y: Property<Model, Y>,
        _ z: Property<Model, Z>
    ) {
        self.init(
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q),
            PartialProperty(r),
            PartialProperty(s),
            PartialProperty(t),
            PartialProperty(u),
            PartialProperty(v),
            PartialProperty(w),
            PartialProperty(x),
            PartialProperty(y),
            PartialProperty(z)
        )
    }

    public init<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z>(
        _ initializer: Initializer<Model, ((A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z))>,
        _ a: Property<Model, A>,
        _ b: Property<Model, B>,
        _ c: Property<Model, C>,
        _ d: Property<Model, D>,
        _ e: Property<Model, E>,
        _ f: Property<Model, F>,
        _ g: Property<Model, G>,
        _ h: Property<Model, H>,
        _ i: Property<Model, I>,
        _ j: Property<Model, J>,
        _ k: Property<Model, K>,
        _ l: Property<Model, L>,
        _ m: Property<Model, M>,
        _ n: Property<Model, N>,
        _ o: Property<Model, O>,
        _ p: Property<Model, P>,
        _ q: Property<Model, Q>,
        _ r: Property<Model, R>,
        _ s: Property<Model, S>,
        _ t: Property<Model, T>,
        _ u: Property<Model, U>,
        _ v: Property<Model, V>,
        _ w: Property<Model, W>,
        _ x: Property<Model, X>,
        _ y: Property<Model, Y>,
        _ z: Property<Model, Z>
    ) {
        self.init(
            name: initializer.name,
            PartialProperty(a),
            PartialProperty(b),
            PartialProperty(c),
            PartialProperty(d),
            PartialProperty(e),
            PartialProperty(f),
            PartialProperty(g),
            PartialProperty(h),
            PartialProperty(i),
            PartialProperty(j),
            PartialProperty(k),
            PartialProperty(l),
            PartialProperty(m),
            PartialProperty(n),
            PartialProperty(o),
            PartialProperty(p),
            PartialProperty(q),
            PartialProperty(r),
            PartialProperty(s),
            PartialProperty(t),
            PartialProperty(u),
            PartialProperty(v),
            PartialProperty(w),
            PartialProperty(x),
            PartialProperty(y),
            PartialProperty(z)
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
