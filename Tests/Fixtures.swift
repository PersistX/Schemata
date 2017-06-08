import Schemata

// MARK: - RBook

struct RBook {
    struct ID {
        let string: String
        
        init(_ string: String) {
            self.string = string
        }
    }
    
    let id: ID
    let title: String
    let author: RAuthor
}

extension RBook.ID: Hashable {
    var hashValue: Int {
        return string.hashValue
    }
    
    static func == (lhs: RBook.ID, rhs: RBook.ID) -> Bool {
        return lhs.string == rhs.string
    }
}

extension RBook: Hashable {
    var hashValue: Int {
        return id.hashValue ^ title.hashValue ^ author.hashValue
    }
    
    static func == (lhs: RBook, rhs: RBook) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.author == rhs.author
    }
}

extension RBook.ID: RecordValue {
    static let record = String.record.bimap(
        decode: RBook.ID.init,
        encode: { $0.string }
    )
}

extension RBook: RecordModel {
    static let record = Schema<Record, RBook>(
        RBook.init,
        \.id ~ "id",
        \.title ~ "title",
        \.author ~ "author"
    )
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
    let name: String
    let books: Set<RBook>
}

extension RAuthor.ID: Hashable {
    var hashValue: Int {
        return string.hashValue
    }
    
    static func == (lhs: RAuthor.ID, rhs: RAuthor.ID) -> Bool {
        return lhs.string == rhs.string
    }
}

extension RAuthor: Hashable {
    var hashValue: Int {
        return id.hashValue ^ name.hashValue ^ books.hashValue
    }
    
    static func == (lhs: RAuthor, rhs: RAuthor) -> Bool {
        return lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.books == rhs.books
    }
}

extension RAuthor.ID: RecordValue {
    static let record = String.record.bimap(
        decode: RAuthor.ID.init,
        encode: { $0.string }
    )
}

extension RAuthor: RecordModel {
    static let record = Schema<Record, RAuthor>(
        RAuthor.init,
        \.id ~ "id",
        \.name ~ "name",
        \.books ~ \RBook.author
    )
}

struct RBookViewModel {
    let title: String
    let authorName: String
}

extension RBookViewModel {
    static let projection = Projection<RBook, RBookViewModel>(
        RBookViewModel.init,
        \.title,
        \.author.name
    )
}
