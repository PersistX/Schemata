import Foundation

public struct Projection<Model: Schemata.Model, Value> {
    fileprivate let make: ([PartialKeyPath<Model>: Any]) -> Value
    
    fileprivate init(make: @escaping ([PartialKeyPath<Model>: Any]) -> Value) {
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
        self.init { values in
            return f(
                values[a] as! A,
                values[b] as! B
            )
        }
    }
}
