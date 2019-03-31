public struct Initializer<Model: Schemata.Model, Arguments> {
    public let name: String
}

public func ~ <Model, A>(
    _: (A) -> Model,
    rhs: String
) -> Initializer<Model, A> {
    return Initializer(name: rhs)
}
