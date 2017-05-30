import Foundation

public struct Projection<Format: Schemata.Format, Model, Value> {
    
}

extension Projection where Format == Record, Model: RecordObject {
    public init<A, B>(
        _ f: @escaping (A, B) -> Value,
        _ a: KeyPath<Model, A>,
        _ b: KeyPath<Model, B>
    ) {
        fatalError()
    }
}
