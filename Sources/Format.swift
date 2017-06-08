import Foundation
import Result

public protocol FormatValue: Hashable {
    typealias Decoder<T> = (Self) -> Result<T, ValueError>
    typealias Encoder<T> = (T) -> Self
}

public protocol Format {
    init()
    
    subscript(_ path: String) -> String? { get set }
}
