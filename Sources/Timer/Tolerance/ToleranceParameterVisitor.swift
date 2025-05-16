import SwiftSyntax

class ToleranceParameterVisitor: SyntaxVisitor {
    
    private var views: [String] = []
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        guard let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self),
              memberAccess.declName.baseName.text == "publish",
              let base = memberAccess.base?.as(DeclReferenceExprSyntax.self),
              base.baseName.text == "Timer" else {
            return .visitChildren
        }
        
        print(node)
        
        let hasToleranceParameter = node.arguments.contains { argument in
            argument.label?.text == "tolerance"
        }
        
        if !hasToleranceParameter {
            views.append(node.description)
        }
        
        return .visitChildren
    }
    
    func getViews() -> [String] {
        return views
    }
}
