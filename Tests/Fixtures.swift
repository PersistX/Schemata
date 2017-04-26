import Foundation
import Schemata

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

struct Author: Equatable {
    struct ID: Equatable {
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
    
    let id: ID
    var name: String
    
    static func ==(_ lhs: Author, _ rhs: Author) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
