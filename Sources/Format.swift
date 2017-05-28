import Foundation
import Result

public protocol FormatValue: Hashable {
    typealias Decoder<T> = (Self) -> Result<T, Error>
    typealias Encoder<T> = (T) -> Self
    
    associatedtype Error: Swift.Error, Hashable
}

precedencegroup SchemataDecodePrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
    lowerThan: NilCoalescingPrecedence
}

infix operator ~ : SchemataDecodePrecedence

public protocol Format {
    associatedtype Error: Swift.Error, Hashable
    associatedtype Path: Hashable, CustomDebugStringConvertible
    associatedtype Value: FormatValue
    
    init()
    subscript(_ path: Path) -> Value? { get set }
    
    func decode<T>(_ path: Path, _ decode: (Value) -> Result<T, Value.Error>) -> Result<T, DecodeError<Self>>
}
