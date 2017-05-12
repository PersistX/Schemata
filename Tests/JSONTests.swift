import Schemata
import XCTest

extension Author.ID: JSONValue {
    static let json = Value<Author.ID, JSON>(
        decode: { value in
            return String.json
                .decode(value)
                .flatMap { string in
                    if string.contains("#") {
                        let path = JSON.Path([])
                        let error = JSON.Error.invalidValue(value, description: "no #s allowed")
                        return .failure(DecodeError([path: error]))
                    } else {
                        return .success(Author.ID(string))
                    }
                }
        },
        encode: { id in
            return String.json.encode(id.string)
        }
    )
}

extension Author: JSONObject {
    static let json = Schema<Author, JSON>(
        Author.init,
        Author.id ~ "id",
        Author.name ~ "name"
    )
}

extension Book.ID: JSONValue {
    static let json = String.json.bimap(
        decode: Book.ID.init,
        encode: { $0.string }
    )
}

extension Book: JSONObject {
    static let json = Schema<Book, JSON>(
        Book.init,
        Book.id ~ "id",
        Book.title ~ "title",
        Book.author ~ "author"
    )
}

class JSONTests: XCTestCase {
    func testStringDecodeFailure() {
        XCTAssertEqual(
            String.json.decode(.null).error,
            DecodeError([
                JSON.Path([]): .typeMismatch(expected: String.self, actual: .null)
            ])
        )
    }
    
    func testStringDecodeSuccess() {
        let result = String.json.decode(.string("foo"))
        XCTAssertEqual(result.value, "foo")
        XCTAssertNil(result.error)
    }
    
    func testStringEncode() {
        XCTAssertEqual(String.json.encode("foo"), .string("foo"))
    }
    
    func testAuthorIDDecodeTypeMismatchFailure() {
        XCTAssertEqual(
            Author.ID.json.decode(.null).error,
            DecodeError([
                JSON.Path([]): .typeMismatch(expected: String.self, actual: .null)
            ])
        )
    }
    
    func testAuthorIDDecodeInvalidValueFailure() {
        XCTAssertEqual(
            Author.ID.json.decode(.string("#")).error,
            DecodeError([
                JSON.Path([]): .invalidValue(.string("#"), description: "no #s allowed")
            ])
        )
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
        let json = JSON([
            "id": .string(id.string),
            "name": .string(name),
        ])
        XCTAssertEqual(Author.json.decode(json).value, author)
    }
    
    func testAuthorEncode() {
        let id = Author.ID("1")
        let name = "Ray Bradbury"
        let author = Author(id: id, name: name)
        let json = JSON([
            "id": .string(id.string),
            "name": .string(name),
        ])
        XCTAssertEqual(Author.json.encode(author), json)
    }
    
    func testBookDecodeFailure() {
        
    }
    
    func testBookDecodeSuccess() {
        let author = Author(
            id: Author.ID("1"),
            name: "Ray Bradbury"
        )
        let book = Book(
            id: Book.ID("a"),
            title: "The Martian Chronicles",
            author: author
        )
        let json = JSON([
            "id": .string(book.id.string),
            "title": .string(book.title),
            "author": .object(JSON([
                "id": .string(author.id.string),
                "name": .string(author.name)
            ])),
        ])
        XCTAssertEqual(Book.json.decode(json).value, book)
    }
    
    func testBookEncode() {
        let author = Author(
            id: Author.ID("1"),
            name: "Ray Bradbury"
        )
        let book = Book(
            id: Book.ID("a"),
            title: "The Martian Chronicles",
            author: author
        )
        let json = JSON([
            "id": .string(book.id.string),
            "title": .string(book.title),
            "author": .object(JSON([
                "id": .string(author.id.string),
                "name": .string(author.name)
            ])),
        ])
        XCTAssertEqual(Book.json.encode(book), json)
    }
}


