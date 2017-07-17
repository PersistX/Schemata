import Schemata
import XCTest

class UUIDModelValueTests: XCTestCase {
    func test_decode_success() {
        let uuid = UUID(uuidString: "4716e603-6f6a-438d-8659-c559a320d5d9")!
        XCTAssertEqual(UUID.value.decode(uuid.uuidString).value, uuid)
    }
    
    func test_decode_failure() {
        XCTAssertNotNil(UUID.value.decode("junk").error)
    }
    
    func test_encode() {
        let uuid = UUID(uuidString: "4716e603-6f6a-438d-8659-c559a320d5d9")!
        XCTAssertEqual(UUID.value.encode(uuid), uuid.uuidString)
    }
}
