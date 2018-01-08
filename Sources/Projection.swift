import Foundation

/// A projection from some Model type to a Value type.
///
/// Given a dictionary of values used in the projection, this can be used to create a `Value`.
public struct Projection<Model: Schemata.Model, Value> {
    /// The `KeyPath`s that are required to create a `Value`.
    public let keyPaths: Set<PartialKeyPath<Model>>
    
    fileprivate let make: ([PartialKeyPath<Model>: Any]) -> Value
    
    fileprivate init(
        _ keyPaths: Set<PartialKeyPath<Model>>,
        make: @escaping ([PartialKeyPath<Model>: Any]) -> Value
    ) {
        self.keyPaths = keyPaths
        self.make = make
    }
    
    public func makeValue(_ values: [PartialKeyPath<Model>: Any]) -> Value {
        return make(values)
    }
}

extension Projection {
    public init<A>(
        _ make: @escaping (A) -> Value,
        _ a: KeyPath<Model, A>
    ) {
        self.init([a]) { values in
            return make(
                values[a] as! A
            )
        }
    }
    
    public init<A, B>(
        _ make: @escaping (A, B) -> Value,
        _ a: KeyPath<Model, A>,
        _ b: KeyPath<Model, B>
    ) {
        self.init([a, b]) { values in
            return make(
                values[a] as! A,
                values[b] as! B
            )
        }
    }
    
    public init<A, B, C>(
        _ make: @escaping (A, B, C) -> Value,
        _ a: KeyPath<Model, A>,
        _ b: KeyPath<Model, B>,
        _ c: KeyPath<Model, C>
    ) {
        self.init([a, b, c]) { values in
            return make(
                values[a] as! A,
                values[b] as! B,
                values[c] as! C
            )
        }
    }
    
    public init<A, B, C, D>(
        _ make: @escaping (A, B, C, D) -> Value,
        _ a: KeyPath<Model, A>,
        _ b: KeyPath<Model, B>,
        _ c: KeyPath<Model, C>,
        _ d: KeyPath<Model, D>
    ) {
        self.init([a, b, c, d]) { values in
            return make(
                values[a] as! A,
                values[b] as! B,
                values[c] as! C,
                values[d] as! D
            )
        }
    }
    
    public init<A, B, C, D, E>(
        _ make: @escaping (A, B, C, D, E) -> Value,
        _ a: KeyPath<Model, A>,
        _ b: KeyPath<Model, B>,
        _ c: KeyPath<Model, C>,
        _ d: KeyPath<Model, D>,
        _ e: KeyPath<Model, E>
    ) {
        self.init([a, b, c, d, e]) { values in
            return make(
                values[a] as! A,
                values[b] as! B,
                values[c] as! C,
                values[d] as! D,
                values[e] as! E
            )
        }
    }
    
    public init<A, B, C, D, E, F>(
        _ make: @escaping (A, B, C, D, E, F) -> Value,
        _ a: KeyPath<Model, A>,
        _ b: KeyPath<Model, B>,
        _ c: KeyPath<Model, C>,
        _ d: KeyPath<Model, D>,
        _ e: KeyPath<Model, E>,
        _ f: KeyPath<Model, F>
    ) {
        self.init([a, b, c, d, e, f]) { values in
            return make(
                values[a] as! A,
                values[b] as! B,
                values[c] as! C,
                values[d] as! D,
                values[e] as! E,
                values[f] as! F
            )
        }
    }
}
