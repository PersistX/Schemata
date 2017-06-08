import Schemata

// MARK: - Book

struct Book {
    struct ID {
        let string: String
        
        init(_ string: String) {
            self.string = string
        }
    }
    
    let id: ID
    let title: String
    let author: Author
}

extension Book.ID: Hashable {
    var hashValue: Int {
        return string.hashValue
    }
    
    static func == (lhs: Book.ID, rhs: Book.ID) -> Bool {
        return lhs.string == rhs.string
    }
}

extension Book: Hashable {
    var hashValue: Int {
        return id.hashValue ^ title.hashValue ^ author.hashValue
    }
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.author == rhs.author
    }
}

extension Book.ID: ModelValue {
    static let value = String.value.bimap(
        decode: Book.ID.init,
        encode: { $0.string }
    )
}

extension Book: RecordModel {
    static let record = Schema<Record, Book>(
        Book.init,
        \.id ~ "id",
        \.title ~ "title",
        \.author ~ "author"
    )
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
    let name: String
    let books: Set<Book>
}

extension Author.ID: Hashable {
    var hashValue: Int {
        return string.hashValue
    }
    
    static func == (lhs: Author.ID, rhs: Author.ID) -> Bool {
        return lhs.string == rhs.string
    }
}

extension Author: Hashable {
    var hashValue: Int {
        return id.hashValue ^ name.hashValue ^ books.hashValue
    }
    
    static func == (lhs: Author, rhs: Author) -> Bool {
        return lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.books == rhs.books
    }
}

extension Author.ID: ModelValue {
    static let value = String.value.bimap(
        decode: Author.ID.init,
        encode: { $0.string }
    )
}

extension Author: RecordModel {
    static let record = Schema<Record, Author>(
        Author.init,
        \.id ~ "id",
        \.name ~ "name",
        \.books ~ \Book.author
    )
}

struct BookViewModel {
    let title: String
    let authorName: String
}

extension BookViewModel {
    static let projection = Projection<Book, BookViewModel>(
        BookViewModel.init,
        \.title,
        \.author.name
    )
}
