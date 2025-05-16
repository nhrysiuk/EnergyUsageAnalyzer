import SwiftSyntax

class PublishTimerStartVisitor: SyntaxVisitor {
    
    private var names: [String] = []
    private var views: [String] = []
    
    override func visit(_ node: SequenceExprSyntax) -> SyntaxVisitorContinueKind {
        if let method = node.elements.last?.as(FunctionCallExprSyntax.self),
           let memberAccess1 = method.calledExpression.as(MemberAccessExprSyntax.self),
           let base1 = memberAccess1.base?.as(FunctionCallExprSyntax.self),
           let memberAccess2 = base1.calledExpression.as(MemberAccessExprSyntax.self),
           let base2 = memberAccess2.base?.as(FunctionCallExprSyntax.self),
           let memberAccess3 = base2.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess3.base?.as(DeclReferenceExprSyntax.self)?.baseName.text == "Timer",
           memberAccess3.declName.baseName.text == "publish",
           let declReference = node.elements.first?.as(DeclReferenceExprSyntax.self) {
                names.append(declReference.baseName.text)
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
