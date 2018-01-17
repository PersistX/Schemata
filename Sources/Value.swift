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
        decode = { .success($0) }
        encode = { $0 }
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
        case unit
    }

    public typealias Decoder = (Primitive) -> Result<Any, ValueError>
    public typealias Encoder = (Any) -> Primitive

    public let encoded: Encoded
    public let encode: Encoder
    public let decoded: Any.Type
    public let decode: Decoder
}

extension AnyValue {
    public init<Decoded>(_ value: Value<Date, Decoded>) {
        decoded = Decoded.self
        encoded = .date
        encode = { .date(value.encode($0 as! Decoded)) } // swiftlint:disable:this force_cast
        decode = { primitive in
            if case let .date(date) = primitive {
                return value.decode(date).map { $0 as Any }
            } else {
                return .failure(.typeMismatch)
            }
        }
    }

    public init<Decoded>(_ value: Value<Double, Decoded>) {
        decoded = Decoded.self
        encoded = .double
        encode = { .double(value.encode($0 as! Decoded)) } // swiftlint:disable:this force_cast
        decode = { primitive in
            if case let .double(double) = primitive {
                return value.decode(double).map { $0 as Any }
            } else {
                return .failure(.typeMismatch)
            }
        }
    }

    public init<Decoded>(_ value: Value<Int, Decoded>) {
        decoded = Decoded.self
        encoded = .int
        encode = { .int(value.encode($0 as! Decoded)) } // swiftlint:disable:this force_cast
        decode = { primitive in
            if case let .int(int) = primitive {
                return value.decode(int).map { $0 as Any }
            } else {
                return .failure(.typeMismatch)
            }
        }
    }

    public init<Decoded>(_ value: Value<String, Decoded>) {
        decoded = Decoded.self
        encoded = .string
        encode = { .string(value.encode($0 as! Decoded)) } // swiftlint:disable:this force_cast
        decode = { primitive in
            if case let .string(string) = primitive {
                return value.decode(string).map { $0 as Any }
            } else {
                return .failure(.typeMismatch)
            }
        }
    }

    public init<Decoded>(_ value: Value<None, Decoded>) {
        decoded = Decoded.self
        encoded = .unit
        encode = { _ in .null }
        decode = { primitive in
            if case .null = primitive {
                return value.decode(.none).map { $0 as Any }
            } else {
                return .failure(.typeMismatch)
            }
        }
    }
}
