import Foundation

public enum Primitive {
    case date(Date)
    case double(Double)
    case int(Int)
    case null
    case string(String)
}

extension Primitive: Hashable {
    public var hashValue: Int {
        switch self {
        case let .date(date):
            return date.hashValue
        case let .double(double):
            return double.hashValue
        case let .int(int):
            return int.hashValue
        case .null:
            return 0
        case let .string(string):
            return string.hashValue
        }
    }

    public static func ==(lhs: Primitive, rhs: Primitive) -> Bool {
        switch (lhs, rhs) {
        case let (.date(lhs), .date(rhs)):
            return lhs == rhs
        case let (.double(lhs), .double(rhs)):
            return lhs == rhs
        case let (.int(lhs), .int(rhs)):
            return lhs == rhs
        case (.null, .null):
            return true
        case let (.string(lhs), .string(rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}
