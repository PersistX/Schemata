import Schemata
import XCTest

// MARK: - Book

struct Book {
    struct ID {
        let string: String
        
        init(_ string: String) {
            self.string = string
        }
    }
    
    let id: ID
    var title: String
    var author: Author
}

extension Book.ID: Equatable {
    static func == (lhs: Book.ID, rhs: Book.ID) -> Bool {
        return lhs.string == rhs.string
    }
}

extension Book: Equatable {
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.author == rhs.author
    }
}

// MARK: - Author

struct Author {
    struct ID {
        let string: String
        
        init(_ string: String) {
            self.string = string
        }
    }
    
    let id: ID
    var name: String
}

extension Author.ID: Equatable {
    static func == (lhs: Author.ID, rhs: Author.ID) -> Bool {
        return lhs.string == rhs.string
    }
}

extension Author: Equatable {
    static func == (lhs: Author, rhs: Author) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}

extension Author.ID: RecordValue {
    static let record = String.record.bimap(
        decode: Author.ID.init,
        encode: { $0.string }
    )
}

extension Author: RecordObject {
    static let record = Schema<Author, Record>(
        Author.init,
        \Author.id ~ "id",
        \Author.name ~ "name"
    )
}

class RecordTests: XCTestCase {
}
