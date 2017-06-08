import Schemata
import XCTest

class RecordTests: XCTestCase {
    func test_properties_string() {
        let title = Book.schema.properties["title"]!
        XCTAssert(title.model == Book.self)
        XCTAssertEqual(title.keyPath, \Book.title)
        XCTAssertEqual(title.path, "title")
        XCTAssert(title.decoded == String.self)
        XCTAssert(title.encoded == String.self)
    }
    
    func test_propertiesForKeyPath_string() {
        let properties = Book.schema.properties(for: \Book.title)
        XCTAssertEqual(properties, [Book.schema.properties["title"]!])
    }
    
    func test_propertiesForKeyPath_toOne_string() {
        let properties = Book.schema.properties(for: \Book.author.name)
        XCTAssertEqual(properties, [
            Book.schema.properties["author"]!,
            Author.schema.properties["name"]!,
        ])
    }
}
