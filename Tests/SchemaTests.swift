import Schemata
import XCTest

class SchemaTests: XCTestCase {
    func test_properties_string() {
        let title = Book.schema.properties[\.title]!
        XCTAssert(title.model == Book.self)
        XCTAssertEqual(title.keyPath, \Book.title)
        XCTAssertEqual(title.path, "title")
        XCTAssertEqual(title.type, .value(String.self))
    }
    
    func test_propertiesForKeyPath_string() {
        let properties = Book.schema.properties(for: \.title)
        XCTAssertEqual(properties, [Book.schema.properties[\.title]!])
    }
    
    func test_propertiesForKeyPath_toOne_string() {
        let properties = Book.schema.properties(for: \.author.name)
        XCTAssertEqual(properties, [
            Book.schema.properties[\.author]!,
            Author.schema.properties[\.name]!,
        ])
    }
}
