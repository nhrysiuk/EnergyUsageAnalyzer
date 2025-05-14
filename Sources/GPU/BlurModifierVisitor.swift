import Foundation
import SwiftSyntax

class BlurModifierVisitor: SyntaxVisitor, EnergyVisitable {
    
    func analyze(_ sourceFile: SourceFileSyntax) {
        walk(sourceFile)
    }
    
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
