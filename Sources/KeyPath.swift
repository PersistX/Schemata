import Foundation

/// Until Swift 4.0 ships its built-in KeyPath.
public struct KeyPath<Root, Leaf> {
    public let keys: [String]
    
    public init(keys: [String]) {
        self.keys = keys
    }
}

public protocol KeyPathCompliant {
    func value<Leaf>(of keyPath: KeyPath<Self, Leaf>) -> Leaf
}
