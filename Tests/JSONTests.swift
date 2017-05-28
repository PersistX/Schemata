import Result
import Schemata
import XCTest

extension Author.ID: JSONValue {
	static let json = String.json.bimap(
		decode: { string -> Result<Author.ID, DecodeError<JSON>> in
			if string.contains("#") {
				let path = JSON.Path([])
				let error = JSON.Error.invalidValue(.string(string), description: "no #s allowed")
				return .failure(DecodeError([path: error]))
			} else {
				return .success(Author.ID(string))
			}
        },
        encode: { (id: Author.ID) -> String in return id.string }
	)
}

extension Author: JSONObject {
    static let json = Schema<Author, JSON>(
        Author.init,
        \Author.id ~ "id",
        \Author.name ~ "name"
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
        \Book.id ~ "id",
        \Book.title ~ "title",
        \Book.author ~ "author"
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
            Author.ID.json.decode("#").error,
            DecodeError([
                JSON.Path([]): .invalidValue(.string("#"), description: "no #s allowed")
            ])
        )
    }
    
    func testAuthorIDDecodeSuccess() {
        let result = Author.ID.json.decode("foo")
        XCTAssertEqual(result.value, Author.ID("foo"))
        XCTAssertNil(result.error)
    }
    
    func testAuthorIDEncode() {
        XCTAssertEqual(Author.ID.json.encode(Author.ID("foo")), "foo")
    }
    
    func testAuthorDecodeMissingPropertyFailure() {
        let json = JSON([
            "id": .string("#"),
        ])
        XCTAssertEqual(
            Author.json.decode(json).error,
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
            Author.json.decode(json).error,
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
            Author.json.decode(json).error,
            DecodeError([
                JSON.Path(["id"]): .invalidValue(.string("#"), description: "no #s allowed")
            ])
        )
    }
    
    func testAuthorDecodeSuccess() {
        let author = Author(
            id: Author.ID("1"),
            name: "Ray Bradbury"
        )
        let json = JSON([
            "id": .string(author.id.string),
            "name": .string(author.name),
        ])
        XCTAssertEqual(Author.json.decode(json).value, author)
    }
    
    func testAuthorEncode() {
        let author = Author(
            id: Author.ID("1"),
            name: "Ray Bradbury"
        )
        let json = JSON([
            "id": .string(author.id.string),
            "name": .string(author.name),
        ])
        XCTAssertEqual(Author.json.encode(author), json)
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
            Book.json.decode(json).error,
            DecodeError([
                JSON.Path(["author", "id"]): .invalidValue(.string("#"), description: "no #s allowed"),
                JSON.Path(["author", "name"]): .typeMismatch(expected: String.self, actual: .null),
                JSON.Path(["title"]): .missingKey,
            ])
        )
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
	
	func testDebugDescription() {
		XCTAssertEqual(
			Author.json.debugDescription,
			"""
			Author {
			\tid: String (ID)
			\tname: String (String)
			}
			"""
		)
	}
}


