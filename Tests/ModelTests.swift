import Schemata
import XCTest

private let uuid = UUID(uuidString: "4716e603-6f6a-438d-8659-c559a320d5d9")!
private let url = URL(string: "http://example.com/foo")!

class URLModelValueTests: XCTestCase {
    func testDecodeSuccess() throws {
        XCTAssertEqual(try URL.value.decode(url.absoluteString).get(), url)
    }

    func testDecodeFailure() {
        XCTAssertThrowsError(try URL.value.decode("🙄").get())
    }

    func testEncode() {
        XCTAssertEqual(URL.value.encode(url), url.absoluteString)
    }
}

class UUIDModelValueTests: XCTestCase {
    func testDecodeSuccess() throws {
        XCTAssertEqual(try UUID.value.decode(uuid.uuidString).get(), uuid)
    }

    func testDecodeFailure() {
        XCTAssertThrowsError(try UUID.value.decode("junk").get())
    }

    func testEncode() {
        XCTAssertEqual(UUID.value.encode(uuid), uuid.uuidString)
    }
}

class OptionalModalValueTests: XCTestCase {
    func testDecodeNil() throws {
        XCTAssertNil(try UUID?.value.decode(nil).get())
    }

    func testDecodeWrapped() {
        XCTAssertEqual(try UUID?.value.decode(uuid.uuidString).get(), uuid)
    }

    func testDecodeFailure() {
        XCTAssertThrowsError(try UUID?.value.decode("junk").get())
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
        XCTAssertEqual(try result.get() as? UUID, nil)
    }

    func testDecodeWrapped() {
        XCTAssertEqual(try UUID?.anyValue.decode(.string(uuid.uuidString)).get() as? UUID, uuid)
    }

    func testDecodeFailure() {
        XCTAssertThrowsError(try UUID?.anyValue.decode(.string("junk")).get())
    }

    func testEncodeNil() {
        let anyValue = UUID?.anyValue
        XCTAssertEqual(anyValue.encode(UUID?.none as Any), .null)
    }

    func testEncodeWrapped() {
        XCTAssertEqual(UUID?.anyValue.encode(uuid), .string(uuid.uuidString))
    }
}
