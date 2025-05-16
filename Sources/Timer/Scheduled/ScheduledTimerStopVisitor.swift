import SwiftSyntax

class ScheduledTimerStopVisitor: SyntaxVisitor {
    
    private var managerNames: [String] = []
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        if let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "invalidate",
           let timerName = memberAccess.base?.description.trimmingCharacters(in: .whitespacesAndNewlines) {
            let cleanName = timerName.replacingOccurrences(of: "?", with: "")
            managerNames.append(cleanName.replacingOccurrences(of: "self.", with: ""))
        }
        return .visitChildren
    }

    func getNames() -> [String] {
        return managerNames
    }
}
