import Foundation
import SwiftSyntax

class BluetoothStopVisitor: SyntaxVisitor {
    
    private var managerNames: [String] = []
    private var views: [String] = []
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        if let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "stopScan",
           let managerName = memberAccess.base?.description.trimmingCharacters(in: .whitespacesAndNewlines) {
            managerNames.append(managerName.replacingOccurrences(of: "self.", with: ""))
        }
        return .visitChildren
    }
    
    func getViews() -> [String] {
        return views
    }
    
    func getNames() -> [String] {
        return managerNames
    }
}
