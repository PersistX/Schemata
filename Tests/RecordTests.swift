import Schemata
import XCTest

class RecordTests: XCTestCase {
    func test_properties_string() {
        let title = RBook.record.properties["title"]!
        XCTAssert(title.model == RBook.self)
        XCTAssertEqual(title.keyPath, \RBook.title)
        XCTAssertEqual(title.path, "title")
        XCTAssert(title.decoded == String.self)
        XCTAssert(title.encoded == String.self)
    }
    
    func test_propertiesForKeyPath_string() {
        let properties = RBook.record.properties(for: \RBook.title)
        XCTAssertEqual(properties, [RBook.record.properties["title"]!])
    }
    
    func test_propertiesForKeyPath_toOne_string() {
        let properties = RBook.record.properties(for: \RBook.author.name)
        XCTAssertEqual(properties, [
            RBook.record.properties["author"]!,
            RAuthor.record.properties["name"]!,
        ])
    }
}
