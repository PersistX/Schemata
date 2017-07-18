import Foundation
import Result

public struct Value<Encoded, Decoded> {
    public typealias Decoder = (Encoded) -> Result<Decoded, ValueError>
    public typealias Encoder = (Decoded) -> Encoded
    
    public let decode: Decoder
    public let encode: Encoder
    
    internal init(decode: @escaping Decoder, encode: @escaping Encoder) {
        self.decode = decode
        self.encode = encode
    }
}

extension Value where Encoded == Decoded {
    internal init() {
        self.decode = { .success($0) }
        self.encode = { $0 }
    }
}

extension Value {
    public func bimap<NewDecoded>(
        decode: @escaping (Decoded) -> NewDecoded,
        encode: @escaping (NewDecoded) -> Decoded
    ) -> Value<Encoded, NewDecoded> {
        return Value<Encoded, NewDecoded>(
            decode: { self.decode($0).map(decode) },
            encode: { self.encode(encode($0)) }
        )
    }
    
    public func bimap<NewDecoded>(
        decode: @escaping (Decoded) -> Result<NewDecoded, ValueError>,
        encode: @escaping (NewDecoded) -> Decoded
    ) -> Value<Encoded, NewDecoded> {
        return Value<Encoded, NewDecoded>(
            decode: { self.decode($0).flatMap(decode) },
            encode: { self.encode(encode($0)) }
        )
    }
}

public struct AnyValue {
    public enum Encoded {
        case date
        case double
        case int
        case string
    }
    
    public typealias Decoder = (Primitive) -> Result<Any, ValueError>
    public typealias Encoder = (Any) -> Primitive
    
    public let encoded: Encoded
    public let encode: Encoder
    public let decoded: Any.Type
    public let decode: Decoder
    
    public init<Encoded, Decoded>(_ value: Value<Encoded, Decoded>) {
        decoded = Decoded.self
        
        if Encoded.self == Date.self {
            encoded = .date
            encode = { .date(value.encode($0 as! Decoded) as! Date) }
            decode = { primitive in
                if case let .date(date) = primitive {
                    return value.decode(date as! Encoded).map { $0 as Any }
                } else {
                    return .failure(.typeMismatch)
                }
            }
        } else if Encoded.self == Double.self {
            encoded = .double
            encode = { .double(value.encode($0 as! Decoded) as! Double) }
            decode = { primitive in
                if case let .double(double) = primitive {
                    return value.decode(double as! Encoded).map { $0 as Any }
                } else {
                    return .failure(.typeMismatch)
                }
            }
        } else if Encoded.self == Int.self {
            encoded = .int
            encode = { .int(value.encode($0 as! Decoded) as! Int) }
            decode = { primitive in
                if case let .int(int) = primitive {
                    return value.decode(int as! Encoded).map { $0 as Any }
                } else {
                    return .failure(.typeMismatch)
                }
            }
        } else if Encoded.self == String.self {
            encoded = .string
            encode = { .string(value.encode($0 as! Decoded) as! String) }
            decode = { primitive in
                if case let .string(string) = primitive {
                    return value.decode(string as! Encoded).map { $0 as Any }
                } else {
                    return .failure(.typeMismatch)
                }
            }
        } else {
            fatalError("Can't construct AnyValue that encodes to \(Encoded.self)")
        }
    }
}
