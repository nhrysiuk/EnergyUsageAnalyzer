import Foundation
import SwiftSyntax

class AlphaPropertyVisitor: SyntaxVisitor {
    
    private var views: [String] = []
    
    override func visit(_ node: SequenceExprSyntax) -> SyntaxVisitorContinueKind {
        if let memberAccess = node.elements.first?.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "alpha",
           let floatLiteral = node.elements.last?.as(FloatLiteralExprSyntax.self),
           let alphaValue = Double(floatLiteral.literal.text),
           alphaValue > 0.0 && alphaValue < 1.0 {
            views.append(node.description)
        }
        return .visitChildren
    }
    
    func getViews() -> [String] {
        return views
    }
}
