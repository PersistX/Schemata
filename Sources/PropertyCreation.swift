import Foundation

precedencegroup SchemataPropertyCreationPrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
    lowerThan: NilCoalescingPrecedence
}

infix operator ~: SchemataPropertyCreationPrecedence

public func ~ <Model, Child: Schemata.Model>(
    lhs: KeyPath<Model, Set<Child>>,
    _: KeyPath<Child, Model>
) -> Property<Model, Set<Child>> {
    return Property<Model, Set<Child>>(
        keyPath: lhs,
        path: "(\(Child.self))",
        type: .toMany(Child.self)
    )
}

public func ~ <Model, Value: Schemata.Model>(
    lhs: KeyPath<Model, Value>,
    rhs: String
) -> Property<Model, Value> {
    return Property<Model, Value>(
        keyPath: lhs,
        path: rhs,
        type: .toOne(Value.self, nullable: false)
    )
}

public func ~ <Model, Value: ModelValue>(
    lhs: KeyPath<Model, Value>,
    rhs: String
) -> Property<Model, Value> {
    return Property<Model, Value>(
        keyPath: lhs,
        path: rhs,
        type: .value(Value.self, nullable: false)
    )
}

public func ~ <Model, Value: ModelValue>(
    lhs: KeyPath<Model, Value?>,
    rhs: String
) -> Property<Model, Value?> {
    return Property<Model, Value?>(
        keyPath: lhs,
        path: rhs,
        type: .value(Value.self, nullable: true)
    )
}
