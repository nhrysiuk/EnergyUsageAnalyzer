import Foundation
import SwiftSyntax

class BluetoothStartVisitor: SyntaxVisitor {
    
    private var warningsDictionary: [String : WarningMessage] = [:]
    private let filePath: String
    
    init(filePath: String) {
        self.filePath = filePath
        super.init(viewMode: .all)
    }
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        if let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "scanForPeripherals",
           let managerName = memberAccess.base?.description.trimmingCharacters(in: .whitespacesAndNewlines) {
            let location = node.startLocation(converter: SourceLocationConverter(fileName: filePath, tree: node.root))
            let warningMessage = WarningMessage(filePath: filePath, line: location.line, column: location.column, message: "Found a Bluetooth scanning call without a corresponding stop. Make sure to stop scanning when it's no longer needed. (bluetooth_rule)")
            warningsDictionary[managerName] = warningMessage
            
        }
        return .visitChildren
    }
    
    func getViews() -> [String : WarningMessage] {
        return warningsDictionary
    }
}
