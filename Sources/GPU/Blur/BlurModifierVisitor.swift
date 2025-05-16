import SwiftSyntax

class BlurModifierVisitor: SyntaxVisitor {
    
    private var views: [String] = []
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        if let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "blur" {
            views.append(node.description)
        }
        return .visitChildren
    }
    
    func getViews() -> [String] {
        return views
    }
}
