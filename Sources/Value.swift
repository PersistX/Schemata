import Foundation

public struct Value<T, Format: Schemata.Format> {
    public typealias Decoder = Format.Value.Decoder<T>
    public typealias Encoder = Format.Value.Encoder<T>
    
    public let decode: Decoder
    public let encode: Encoder
    
    public init(decode: @escaping Decoder, encode: @escaping Encoder) {
        self.decode = decode
        self.encode = encode
    }
}

extension Value {
    public func bimap<NewValue>(
        decode: @escaping (T) -> NewValue,
        encode: @escaping (NewValue) -> T
    ) -> Value<NewValue, Format> {
        return Value<NewValue, Format>(
            decode: { self.decode($0).map(decode) },
            encode: { self.encode(encode($0)) }
        )
    }
}
