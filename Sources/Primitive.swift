import Foundation

public enum Primitive: Hashable {
    case date(Date)
    case double(Double)
    case int(Int)
    case null
    case string(String)
}
