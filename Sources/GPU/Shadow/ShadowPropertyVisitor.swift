import SwiftSyntax

class ShadowPropertyVisitor: SyntaxVisitor {
    
    private var views: [String] = []
    
    override func visit(_ node: SequenceExprSyntax) -> SyntaxVisitorContinueKind {
        if let memberAccess = node.elements.first?.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "shadowOpacity",
           let intLiteral = node.elements.last?.as(IntegerLiteralExprSyntax.self),
           let value = Int(intLiteral.literal.text),
           value > 0  {
            views.append(node.description)
        }
        return .visitChildren
    }
    
    func getViews() -> [String] {
        return views
    }
}
