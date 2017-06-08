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
    associatedtype Value: FormatValue
    
    init()
    subscript(_ path: String) -> Value? { get set }
}
