import Schemata
import XCTest

private let uuid = UUID(uuidString: "4716e603-6f6a-438d-8659-c559a320d5d9")!
private let url = URL(string: "http://example.com/foo")!

class URLModelValueTests: XCTestCase {
    func testDecodeSuccess() {
        XCTAssertEqual(URL.value.decode(url.absoluteString).value, url)
    }

    func testDecodeFailure() {
        XCTAssertNotNil(URL.value.decode("🙄").error)
    }

    func testEncode() {
        XCTAssertEqual(URL.value.encode(url), url.absoluteString)
    }
}

class UUIDModelValueTests: XCTestCase {
    func testDecodeSuccess() {
        XCTAssertEqual(UUID.value.decode(uuid.uuidString).value, uuid)
    }

    func testDecodeFailure() {
        XCTAssertNotNil(UUID.value.decode("junk").error)
    }

    func testEncode() {
        XCTAssertEqual(UUID.value.encode(uuid), uuid.uuidString)
    }
}

class OptionalModalValueTests: XCTestCase {
    func testDecodeNil() {
        XCTAssertNil(UUID?.value.decode(nil).value!)
    }

    func testDecodeWrapped() {
        XCTAssertEqual(UUID?.value.decode(uuid.uuidString).value, uuid)
    }

    func testDecodeFailure() {
        XCTAssertNotNil(UUID?.value.decode("junk").error)
    }

    func testEncodeNil() {
        XCTAssertNil(UUID?.value.encode(nil))
    }

    func testEncodeWrapped() {
        XCTAssertEqual(UUID?.value.encode(uuid), uuid.uuidString)
    }
}

class OptionalModalAnyValueTests: XCTestCase {
    func testDecodeNil() {
        let result = UUID?.anyValue.decode(.null)
        XCTAssertEqual(result.value! as? UUID, nil)
    }

    func testDecodeWrapped() {
        XCTAssertEqual(UUID?.anyValue.decode(.string(uuid.uuidString)).value as? UUID, uuid)
    }

    func testDecodeFailure() {
        XCTAssertNotNil(UUID?.anyValue.decode(.string("junk")).error)
    }

    func testEncodeNil() {
        let anyValue = UUID?.anyValue
        XCTAssertEqual(anyValue.encode(UUID?.none as Any), .null)
    }

    func testEncodeWrapped() {
        XCTAssertEqual(UUID?.anyValue.encode(uuid), .string(uuid.uuidString))
    }
}
