import SwiftSyntax

class ToleranceParameterVisitor: SyntaxVisitor, EnergyVisitable {
    
    private var views: [String] = []
    
    func analyze(_ sourceFile: SwiftSyntax.SourceFileSyntax) {
        walk(sourceFile)
    }
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        guard let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self),
              memberAccess.declName.baseName.text == "publish",
              let base = memberAccess.base?.as(DeclReferenceExprSyntax.self),
              base.baseName.text == "Timer" else {
            return .visitChildren
        }
        
        let hasToleranceParameter = node.arguments.contains { argument in
            argument.label?.text == "tolerance"
        }
        
        if !hasToleranceParameter {
            views.append(node.description)
            print(node.description)
        }
        
        return .visitChildren
    }
    
    func getViews() -> [String] {
        return views
    }
}
