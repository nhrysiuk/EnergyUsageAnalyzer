import SwiftSyntax

class ShadowModifierVisitor: SyntaxVisitor {
    
    private var views: [String] = []
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        if let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "shadow" {
            views.append(node.description.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        return .visitChildren
    }
    
    func getViews() -> [String] {
        return views
    }
}
