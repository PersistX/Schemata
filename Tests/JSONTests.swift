import Schemata
import XCTest

private struct Book {
    struct ID {
        let string: String
    }
    
    let id: ID
    var title: String
    var author: Author
}

extension KeyPath where Root == Book {
    var id: KeyPath<Root, Book.ID> { return KeyPath<Root, Book.ID>(keys: keys + ["id"]) }
    var author: KeyPath<Root, Author> { return KeyPath<Root, Author>(keys: keys + ["author"]) }
    var title: KeyPath<Root, String> { return KeyPath<Root, String>(keys: keys + ["title"]) }
}

extension Book {
    private static let root = KeyPath<Book, Book>(keys: [])
    static let id = root.id
    static let author = root.author
    static let title = root.title
}

extension KeyPath where Root == Author {
    var id: KeyPath<Root, Author.ID> { return KeyPath<Root, Author.ID>(keys: keys + ["id"]) }
    var name: KeyPath<Root, String> { return KeyPath<Root, String>(keys: keys + ["name"]) }
}

extension Author: KeyPathCompliant {
    static private let root = KeyPath<Author, Author>(keys: [])
    static let id = root.id
    static let name = root.name
    
    func value<Value>(of keyPath: KeyPath<Author, Value>) -> Value {
        switch keyPath.keys.first {
        case "id"?:
            return id as! Value
        case "name"?:
            return name as! Value
        default:
            fatalError()
        }
    }
}

private struct Author: Equatable, JSONMapped {
    struct ID: Equatable, JSONMapped {
        static let json = String.json.bimap(
            decode: Author.ID.init,
            encode: { $0.string }
        )
        
        let string: String
        
        init(_ string: String) {
            self.string = string
        }
        
        static func ==(_ lhs: ID, _ rhs: ID) -> Bool {
            return lhs.string == rhs.string
        }
        
        func value<Leaf>(of keyPath: KeyPath<Author.ID, Leaf>) -> Leaf {
            fatalError()
        }
    }
    
    static let json = Schema<Author, JSON>(
        Author.init,
        Author.id ~ "id",
        Author.name ~ "name"
    )
    
    let id: ID
    var name: String
    
    static func ==(_ lhs: Author, _ rhs: Author) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
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


