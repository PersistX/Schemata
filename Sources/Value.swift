import Foundation
import Result

public struct Value<Format: Schemata.Format, Encoded, Decoded> {
    public typealias Decoder = (Encoded) -> Result<Decoded, Format.Value.Error>
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
    ) -> Value<Format, Encoded, NewDecoded> {
        return Value<Format, Encoded, NewDecoded>(
            decode: { self.decode($0).map(decode) },
            encode: { self.encode(encode($0)) }
        )
    }
	
	public func bimap<NewDecoded>(
		decode: @escaping (Decoded) -> Result<NewDecoded, Format.Value.Error>,
		encode: @escaping (NewDecoded) -> Decoded
	) -> Value<Format, Encoded, NewDecoded> {
        return Value<Format, Encoded, NewDecoded>(
            decode: { self.decode($0).flatMap(decode) },
            encode: { self.encode(encode($0)) }
        )
	}
}
