import Schemata
import XCTest

// MARK: - RBook

struct RBook {
    struct ID {
        let string: String
        
        init(_ string: String) {
            self.string = string
        }
    }
    
    let id: ID
    var title: String
    var author: RAuthor
}

extension RBook.ID: Equatable {
    static func == (lhs: RBook.ID, rhs: RBook.ID) -> Bool {
        return lhs.string == rhs.string
    }
}

extension RBook: Equatable {
    static func == (lhs: RBook, rhs: RBook) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.author == rhs.author
    }
}

// MARK: - RAuthor

struct RAuthor {
    struct ID {
        let string: String
        
        init(_ string: String) {
            self.string = string
        }
    }
    
    let id: ID
    var name: String
}

extension RAuthor.ID: Equatable {
    static func == (lhs: RAuthor.ID, rhs: RAuthor.ID) -> Bool {
        return lhs.string == rhs.string
    }
}

extension RAuthor: Equatable {
    static func == (lhs: RAuthor, rhs: RAuthor) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}

extension RAuthor.ID: RecordValue {
    static let record = String.record.bimap(
        decode: RAuthor.ID.init,
        encode: { $0.string }
    )
}

extension RAuthor: RecordObject {
    static let record = Schema<RAuthor, Record>(
        RAuthor.init,
        \RAuthor.id ~ "id",
        \RAuthor.name ~ "name"
    )
}

class RecordTests: XCTestCase {
}
