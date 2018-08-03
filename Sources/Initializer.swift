// swiftlint:disable large_tuple

public struct Initializer<Model: Schemata.Model, Arguments> {
    public let name: String
}

public func ~ <Model, A>(
    _: (A) -> Model,
    rhs: String
) -> Initializer<Model, A> {
    return Initializer(name: rhs)
}

public func ~ <Model, A, B>(
    _: (A, B) -> Model,
    rhs: String
) -> Initializer<Model, (A, B)> {
    return Initializer(name: rhs)
}

public func ~ <Model, A, B, C>(
    _: (A, B, C) -> Model,
    rhs: String
) -> Initializer<Model, (A, B, C)> {
    return Initializer(name: rhs)
}

public func ~ <Model, A, B, C, D>(
    _: (A, B, C, D) -> Model,
    rhs: String
) -> Initializer<Model, (A, B, C, D)> {
    return Initializer(name: rhs)
}

public func ~ <Model, A, B, C, D, E>(
    _: (A, B, C, D, E) -> Model,
    rhs: String
) -> Initializer<Model, (A, B, C, D, E)> {
    return Initializer(name: rhs)
}

public func ~ <Model, A, B, C, D, E, F>(
    _: (A, B, C, D, E, F) -> Model,
    rhs: String
) -> Initializer<Model, (A, B, C, D, E, F)> {
    return Initializer(name: rhs)
}

public func ~ <Model, A, B, C, D, E, F, G>(
    _: (A, B, C, D, E, F, G) -> Model,
    rhs: String
) -> Initializer<Model, (A, B, C, D, E, F, G)> {
    return Initializer(name: rhs)
}
