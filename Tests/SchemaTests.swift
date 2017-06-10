import Schemata
import XCTest

class SchemaTests: XCTestCase {
    // MARK: subscript(_: KeyPath)
    
    func test_subscript_string() {
        let title = Book.schema[\.title]
        XCTAssertEqual(title.keyPath, \Book.title)
        XCTAssertEqual(title.path, "title")
        XCTAssertEqual(title.type, .value(String.self))
    }
    
    func test_subscript_toOne_string() {
        let author = Book.schema[\.author]
        XCTAssertEqual(author.keyPath, \Book.author)
        XCTAssertEqual(author.path, "author")
        XCTAssertEqual(author.type, .toOne(Author.self))
    }
    
    func test_subscript_toMany_string() {
        let books = Author.schema[\.books]
        XCTAssertEqual(books.keyPath, \Author.books)
        XCTAssertEqual(books.path, "(Book)")
        XCTAssertEqual(books.type, .toMany(Book.self))
    }
    
    // MARK: - properties(for: KeyPath)
    
    func test_propertiesForKeyPath_string() {
        let properties = Book.schema.properties(for: \.title)
        XCTAssertEqual(properties, [Book.schema[\.title]])
    }
    
    func test_propertiesForKeyPath_toOne_string() {
        let properties = Book.schema.properties(for: \.author.name)
        XCTAssertEqual(properties, [
            Book.schema[\.author],
            Author.schema[\.name],
        ])
    }
    
    func test_propertiesForKeyPath_toMany() {
        let properties = Author.schema.properties(for: \.books)
        XCTAssertEqual(properties, [
            Author.schema[\.books],
        ])
    }
}
