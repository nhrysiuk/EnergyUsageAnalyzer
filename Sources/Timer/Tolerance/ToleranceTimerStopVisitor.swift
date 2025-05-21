import SwiftSyntax

class ToleranceTimerStopVisitor: SyntaxVisitor {

    private var managerNames: [String] = []
    
    override func visit(_ node: SequenceExprSyntax) -> SyntaxVisitorContinueKind {
        if let memberAccess = node.elements.first?.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "tolerance",
           let base = memberAccess.base?.description.trimmingCharacters(in: .whitespacesAndNewlines) {
            let timerName = base.replacingOccurrences(of: "?", with: "").replacingOccurrences(of: "self.", with: "")
            managerNames.append(timerName)
        }
        return .visitChildren
    }

    func getNames() -> [String] {
        return managerNames
    }
}
