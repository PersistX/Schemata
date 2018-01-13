import Schemata
import XCTest

class ProjectionTests: XCTestCase {
    func test_keyPaths() {
        let projection = BookViewModel.projection
        XCTAssertEqual(projection.keyPaths, [
            \Book.title,
            \Book.author.name,
        ])
    }

    func test_makeValue() {
        let viewModel = BookViewModel(
            title: "The Martian Chronicles",
            authorName: "Ray Bradbury"
        )
        let values: [PartialKeyPath<Book>: Any] = [
            \Book.title: viewModel.title,
            \Book.author.name: viewModel.authorName,
        ]
        XCTAssertEqual(BookViewModel.projection.makeValue(values), viewModel)
    }
}
