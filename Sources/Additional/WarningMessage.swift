import Foundation

struct WarningMessage {
    let filePath: String
    let line: Int
    let column: Int
    let message: String
    var type = "warning"

    func format() -> String {
        return "\(filePath):\(line):\(column): \(type): \(message)"
    }

    init(filePath: String, line: Int, column: Int, message: String, type: String = "warning") {
        self.filePath = filePath
        self.line = line
        self.column = column
        self.message = message
        self.type = type
    }
}
