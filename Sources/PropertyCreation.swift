import Foundation

precedencegroup SchemataPropertyCreationPrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
    lowerThan: NilCoalescingPrecedence
}

infix operator ~ : SchemataPropertyCreationPrecedence

public func ~ <Model, Child: Schemata.Model>(
    lhs: KeyPath<Model, Set<Child>>,
    rhs: KeyPath<Child, Model>
) -> Property<Model, Set<Child>> {
    return Property<Model, Set<Child>>(
        keyPath: lhs,
        path: "(\(Child.self))",
        decode: { _ in .success([]) },
        encoded: Set<Child>.self,
        encode: { _ in fatalError() },
        schema: nil
    )
}

public func ~ <Model, Value: Schemata.Model>(
    lhs: KeyPath<Model, Value>,
    rhs: String
) -> Property<Model, Value> {
    return Property<Model, Value>(
        keyPath: lhs,
        path: rhs,
        decode: { _ in fatalError()  },
        encoded: Value.self,
        encode: { _ in fatalError() },
        schema: { Value.schema }
    )
}

public func ~ <Model, Value: ModelValue>(
    lhs: KeyPath<Model, Value>,
    rhs: String
) -> Property<Model, Value> where Value.Encoded == String {
    return Property<Model, Value>(
        keyPath: lhs,
        path: rhs,
        decode: { Value.value.decode($0 as! String) },
        encoded: Value.Encoded.self,
        encode: { Value.value.encode($0) as Any },
        schema: nil
    )
}
