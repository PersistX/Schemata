import Result
import Schemata
import XCTest

// MARK: - Book

struct JBook {
    struct ID {
        let string: String
        
        init(_ string: String) {
            self.string = string
        }
    }
    
    let id: ID
    var title: String
    var author: JAuthor
}

extension JBook.ID: Equatable {
    static func == (lhs: JBook.ID, rhs: JBook.ID) -> Bool {
        return lhs.string == rhs.string
    }
}

extension JBook: Equatable {
    static func == (lhs: JBook, rhs: JBook) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.author == rhs.author
    }
}

// MARK: - Author

struct JAuthor {
    struct ID {
        let string: String
        
        init(_ string: String) {
            self.string = string
        }
    }
    
    let id: ID
    var name: String
}

extension JAuthor.ID: Equatable {
    static func == (lhs: JAuthor.ID, rhs: JAuthor.ID) -> Bool {
        return lhs.string == rhs.string
    }
}

extension JAuthor: Equatable {
    static func == (lhs: JAuthor, rhs: JAuthor) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}

extension JAuthor.ID: JSONValue {
    static let json = String.json.bimap(
        decode: { string -> Result<JAuthor.ID, DecodeError<JSON>> in
            if string.contains("#") {
                let path = JSON.Path([])
                let error = JSON.Error.invalidValue(.string(string), description: "no #s allowed")
                return .failure(DecodeError([path: error]))
            } else {
                return .success(JAuthor.ID(string))
            }
        },
        encode: { (id: JAuthor.ID) -> String in return id.string }
    )
}

extension JAuthor: JSONModel {
    static let json = Schema<JSON, JAuthor>(
        JAuthor.init,
        \.id ~ "id",
        \.name ~ "name"
    )
}

extension JBook.ID: JSONValue {
    static let json = String.json.bimap(
        decode: JBook.ID.init,
        encode: { $0.string }
    )
}

extension JBook: JSONModel {
    static let json = Schema<JSON, JBook>(
        JBook.init,
        \.id ~ "id",
        \.title ~ "title",
        \.author ~ "author"
    )
}

class JSONTests: XCTestCase {
    func testStringDecodeSuccess() {
        let result = String.json.decode("foo")
        XCTAssertEqual(result.value, "foo")
        XCTAssertNil(result.error)
    }
    
    func testStringEncode() {
        XCTAssertEqual(String.json.encode("foo"), "foo")
    }
    
    func testAuthorIDDecodeInvalidValueFailure() {
        XCTAssertEqual(
            JAuthor.ID.json.decode("#").error,
            DecodeError([
                JSON.Path([]): .invalidValue(.string("#"), description: "no #s allowed")
            ])
        )
    }
    
    func testAuthorIDDecodeSuccess() {
        let result = JAuthor.ID.json.decode("foo")
        XCTAssertEqual(result.value, JAuthor.ID("foo"))
        XCTAssertNil(result.error)
    }
    
    func testAuthorIDEncode() {
        XCTAssertEqual(JAuthor.ID.json.encode(JAuthor.ID("foo")), "foo")
    }
    
    func testAuthorDecodeMissingPropertyFailure() {
        let json = JSON([
            "id": .string("#"),
        ])
        XCTAssertEqual(
            JAuthor.json.decode(json).error,
            DecodeError([
                JSON.Path(["id"]): .invalidValue(.string("#"), description: "no #s allowed"),
                JSON.Path(["name"]): .missingKey,
            ])
        )
    }
    
    func testAuthorDecodedTypeMismatchFailure() {
        let json = JSON([
            "id": .null,
            "name": .null,
        ])
        XCTAssertEqual(
            JAuthor.json.decode(json).error,
            DecodeError([
                JSON.Path(["id"]): .typeMismatch(expected: String.self, actual: .null),
                JSON.Path(["name"]): .typeMismatch(expected: String.self, actual: .null),
            ])
        )
    }
    
    func testAuthorDecodeOnePropertyFailure() {
        let json = JSON([
            "id": .string("#"),
            "name": .string("Ray Bradbury"),
        ])
        XCTAssertEqual(
            JAuthor.json.decode(json).error,
            DecodeError([
                JSON.Path(["id"]): .invalidValue(.string("#"), description: "no #s allowed")
            ])
        )
    }
    
    func testAuthorDecodeSuccess() {
        let author = JAuthor(
            id: JAuthor.ID("1"),
            name: "Ray Bradbury"
        )
        let json = JSON([
            "id": .string(author.id.string),
            "name": .string(author.name),
        ])
        XCTAssertEqual(JAuthor.json.decode(json).value, author)
    }
    
    func testAuthorEncode() {
        let author = JAuthor(
            id: JAuthor.ID("1"),
            name: "Ray Bradbury"
        )
        let json = JSON([
            "id": .string(author.id.string),
            "name": .string(author.name),
        ])
        XCTAssertEqual(JAuthor.json.encode(author), json)
    }
    
    func testBookDecodeFailure() {
        let json = JSON([
            "id": .string("1"),
            "author": .object(JSON([
                "id": .string("#"),
                "name": .null
            ])),
        ])
        XCTAssertEqual(
            JBook.json.decode(json).error,
            DecodeError([
                JSON.Path(["author", "id"]): .invalidValue(.string("#"), description: "no #s allowed"),
                JSON.Path(["author", "name"]): .typeMismatch(expected: String.self, actual: .null),
                JSON.Path(["title"]): .missingKey,
            ])
        )
    }
    
    func testBookDecodeObjectTypeMismatchFailure() {
        let json = JSON([
            "id": .string("1"),
            "title": .string("The Martian Chronicles"),
            "author": .null,
        ])
        XCTAssertEqual(
            JBook.json.decode(json).error,
            DecodeError([
                JSON.Path(["author"]): .typeMismatch(expected: JSON.self, actual: .null),
            ])
        )
    }
    
    func testBookDecodeObjectTypeMissingFailure() {
        let json = JSON([
            "id": .string("1"),
            "title": .string("The Martian Chronicles"),
        ])
        XCTAssertEqual(
            JBook.json.decode(json).error,
            DecodeError([
                JSON.Path(["author"]): .missingKey,
            ])
        )
    }
    
    func testBookDecodeSuccess() {
        let author = JAuthor(
            id: JAuthor.ID("1"),
            name: "Ray Bradbury"
        )
        let book = JBook(
            id: JBook.ID("a"),
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
        XCTAssertEqual(JBook.json.decode(json).value, book)
    }
    
    func testBookEncode() {
        let author = JAuthor(
            id: JAuthor.ID("1"),
            name: "Ray Bradbury"
        )
        let book = JBook(
            id: JBook.ID("a"),
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
        XCTAssertEqual(JBook.json.encode(book), json)
    }
    
    func testDebugDescription() {
        XCTAssertEqual(
            JAuthor.json.debugDescription,
            """
            JAuthor {
            \tid: String (ID)
            \tname: String (String)
            }
            """
        )
    }
}
