import Schemata

// MARK: - Book

struct Book: Hashable {
    struct ID: Hashable {
        let string: String

        init(_ string: String) {
            self.string = string
        }
    }

    let id: ID
    let title: String
    let author: Author
}

extension Book.ID: ModelValue {
    static let value = String.value.bimap(
        decode: Book.ID.init,
        encode: { $0.string }
    )
}

extension Book: Model {
    static let schema = Schema<Book>(
        Book.init ~ "books",
        \.id ~ "id",
        \.title ~ "title",
        \.author ~ "author"
    )
}

// MARK: - Author

struct Author: Hashable {
    struct ID: Hashable {
        let string: String

        init(_ string: String) {
            self.string = string
        }
    }

    let id: ID
    let name: String
    let books: Set<Book>
}

extension Author.ID: ModelValue {
    static let value = String.value.bimap(
        decode: Author.ID.init,
        encode: { $0.string }
    )
}

extension Author: Model {
    static let schema = Schema<Author>(
        Author.init,
        \.id ~ "id",
        \.name ~ "name",
        \.books ~ \Book.author
    )
}

struct BookViewModel: Hashable {
    let title: String
    let authorName: String
}

extension BookViewModel: ModelProjection {
    static let projection = Projection<Book, BookViewModel>(
        BookViewModel.init,
        \.title,
        \.author.name
    )
}
