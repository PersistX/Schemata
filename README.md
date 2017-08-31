# Schemata
Schemas and Projections with Swift KeyPaths

## Overview
Schemata lets you build _schemas_ and _projections_ for Swift types using `KeyPath`s. A type that confirms to `Model` or `ModelProjection` by providing a `Schema` or `Projection` has some basic introspection. This can be used for things like [projecting GraphQL types](https://github.com/PersistX/PersistQL).

```swift
// These are classes so that they can refer to each other in a one-to-one
// relationship. If they were structs, then Swift wouldn't be able to construct
// a memory layout for them. But since they're not meant to be instantiated,
// the reference semantics are irrelevant.
final class Book {
    let id: ISBN
    let title: String
    let author: Author
    
    fileprivate init(id: ISBN, title: String, author: Author) {
        // This code should never run. But instantiating the properties lets
        // the compiler guarantee that all the necessary parameters have been
        // added to the `init`.
        self.id = id
        self.title = title
        self.author = author
    }
}

final class Author {
    let id: Author.ID
    let name: String
    let books: Set<Book>
}

extension Book: Model {
    // This `Schema` can be used to:
    //  1. Get a list of the `KeyPath`s in the object
    //  2. Get the name for a given `KeyPath`
    //  3. Break up a `KeyPath` into its individual properties
    static let schema = Schema<Book>(
        Book.init,
        \.id ~ "id",        // The strings here define names for these
        \.title ~ "title",  // properties that can be used for GraphQL fields
        \.author ~ "author" // or database columns.
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

struct BookViewModel {
    let title: String
    let authorName: String
}

extension BookViewModel: ModelProjection {
    // This `Projection` can be used to:
    //  1. Get a list of `Book` `KeyPath`s that are required to create a
    //     `BookViewModel`
    //  2. Create a `BookViewModel` from a `[PartialKeyPath<Book>: Any]`.
    static let projection = Projection<Book, BookViewModel>(
        BookViewModel.init,
        \.title,
        \.author.name
    )
}
```

Schemata exists to provide a type-safe foundation for data projection.

## Limitations
Schemata is somewhat limited due to limitations of Swift itself. These will hopefully be resolved in future versions of Swift.

* [It’s not possible](https://bugs.swift.org/browse/SR-5689) to get the individual properties of `KeyPath`s that have an `Optional` or `Array.

* Ideally, Schemata would be able to use Swift’s `Codable` feature. Unfortunately, there’s no way to relate `KeyPath`s to `CodingKey`s.

## License
Schemata is available under [the MIT license](LICENSE.md).

