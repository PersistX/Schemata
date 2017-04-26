import Schemata
import XCTest

extension Author.ID: JSONMapped {
    static let json = String.json.bimap(
        decode: Author.ID.init,
        encode: { $0.string }
    )
}

extension Author: JSONMapped {
    static let json = Schema<Author, JSON>(
        Author.init,
        Author.id ~ "id",
        Author.name ~ "name"
    )
}

class JSONMappedTests: XCTestCase {
    func testStringDecodeFailure() {
//        XCTAssertEqual(String.json.decode(.null).error, [.typeMismatch(String.self, .null)])
    }
    
    func testStringDecodeSuccess() {
        let result = String.json.decode(.string("foo"))
        XCTAssertEqual(result.value, "foo")
        XCTAssertNil(result.error)
    }
    
    func testStringEncode() {
        XCTAssertEqual(String.json.encode("foo"), .string("foo"))
    }
    
    func testAuthorIDDecodeFailure() {
//        XCTAssertEqual(Author.ID.json.decode(.null).error, [.typeMismatch(Author.ID.self, .null)])
    }
    
    func testAuthorIDDecodeSuccess() {
        let result = Author.ID.json.decode(.string("foo"))
        XCTAssertEqual(result.value, Author.ID("foo"))
        XCTAssertNil(result.error)
    }
    
    func testAuthorIDEncode() {
        XCTAssertEqual(Author.ID.json.encode(Author.ID("foo")), .string("foo"))
    }
    
    func testAuthorDecodeFailure() {
        
    }
    
    func testAuthorDecodeSuccess() {
        let id = Author.ID("1")
        let name = "Ray Bradbury"
        let author = Author(id: id, name: name)
        let json = JSON.object([
            "id": JSON.string(id.string),
            "name": JSON.string(name),
        ])
        XCTAssertEqual(Author.json.decode(json).value, author)
    }
    
    func testAuthorEncode() {
        let id = Author.ID("1")
        let name = "Ray Bradbury"
        let author = Author(id: id, name: name)
        let json = JSON.object([
            "id": JSON.string(id.string),
            "name": JSON.string(name),
        ])
        XCTAssertEqual(Author.json.encode(author), json)
    }
}


