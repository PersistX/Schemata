import Schemata
import XCTest

class SchemaTests: XCTestCase {
    func test_properties_string() {
        let title = Book.schema.properties[\.title]!
        XCTAssertEqual(title.keyPath, \Book.title)
        XCTAssertEqual(title.path, "title")
        XCTAssertEqual(title.type, .value(String.self))
    }
    
    func test_propertiesForKeyPath_string() {
        let properties = Book.schema.properties(for: \.title)
        XCTAssertEqual(properties, [AnyProperty(Book.schema.properties[\.title]!)])
    }
    
    func test_propertiesForKeyPath_toOne_string() {
        let properties = Book.schema.properties(for: \.author.name)
        XCTAssertEqual(properties, [
            AnyProperty(Book.schema.properties[\.author]!),
            AnyProperty(Author.schema.properties[\.name]!),
        ])
    }
}
