import Foundation

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
    public init<A, B>(
        _ f: @escaping (A, B) -> Value,
        _ a: KeyPath<Model, A>,
        _ b: KeyPath<Model, B>
    ) {
        self.init([a, b]) { values in
            return f(
                values[a] as! A,
                values[b] as! B
            )
        }
    }
}
