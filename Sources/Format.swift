import Foundation
import Result

public protocol FormatValue: Hashable {
    typealias Decoder<T> = (Self) -> Result<T, ValueError>
    typealias Encoder<T> = (T) -> Self
}

precedencegroup SchemataDecodePrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
    lowerThan: NilCoalescingPrecedence
}

infix operator ~ : SchemataDecodePrecedence

public protocol Format {
    associatedtype Path: Hashable, CustomDebugStringConvertible
    associatedtype Value: FormatValue
    
    init()
    subscript(_ path: Path) -> Value? { get set }
    
    func decode<T>(_ path: Path, _ decode: (Value) -> Result<T, ValueError>) -> Result<T, DecodeError<Self>>
}
