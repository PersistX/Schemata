import Foundation

public struct Value<Format: Schemata.Format, Decoded> {
    public typealias Decoder = Format.Value.Decoder<Decoded>
    public typealias Encoder = Format.Value.Encoder<Decoded>
    
    public let decode: Decoder
    public let encode: Encoder
    
    public init(decode: @escaping Decoder, encode: @escaping Encoder) {
        self.decode = decode
        self.encode = encode
    }
}

extension Value {
    public func bimap<NewDecoded>(
        decode: @escaping (Decoded) -> NewDecoded,
        encode: @escaping (NewDecoded) -> Decoded
    ) -> Value<Format, NewDecoded> {
        return Value<Format, NewDecoded>(
            decode: { self.decode($0).map(decode) },
            encode: { self.encode(encode($0)) }
        )
    }
}
