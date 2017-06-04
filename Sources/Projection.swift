import Foundation

public struct Projection<Model, Value> {
    
}

extension Projection where Model: RecordModel {
    public init<A, B>(
        _ f: @escaping (A, B) -> Value,
        _ a: KeyPath<Model, A>,
        _ b: KeyPath<Model, B>
    ) {
        fatalError()
    }
}
