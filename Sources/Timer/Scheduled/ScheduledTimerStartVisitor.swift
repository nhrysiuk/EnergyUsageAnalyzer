import SwiftSyntax

class ScheduledTimerStartVisitor: SyntaxVisitor {
    
    private var names: [String] = []
    private var views: [String] = []
    
    override func visit(_ node: SequenceExprSyntax) -> SyntaxVisitorContinueKind {
        if let method = node.elements.last?.as(FunctionCallExprSyntax.self),
           let memberAccess = method.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "scheduledTimer" {
            
            if let declReference = node.elements.first?.as(DeclReferenceExprSyntax.self) {
                names.append(declReference.baseName.text)
                views.append(node.description.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        return .visitChildren
    }
    
    func getViews() -> [String] {
        return views
    }
    
    func getNames() -> [String] {
        return names
    }
}
