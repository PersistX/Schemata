import Foundation
import Schemata

// MARK: - Book

struct Book: KeyPathCompliant {
    struct ID: KeyPathCompliant {
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

struct Author: KeyPathCompliant {
    struct ID: KeyPathCompliant {
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
