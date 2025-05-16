import Foundation
import SwiftSyntax

class InlineMethodCallVisitor: SyntaxVisitor, EnergyVisitable {
    
    func analyze(_ sourceFile: SwiftSyntax.SourceFileSyntax) {
        walk(sourceFile)
    }
    
    private var namesAndViews = [String : String]()
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        if let body = node.body,
           body.statements.count == 1,
           let statement = body.statements.first,
           let functionCall = statement.item.as(FunctionCallExprSyntax.self),
           let expression = functionCall.calledExpression.as(DeclReferenceExprSyntax.self) {
            let name = expression.baseName.text.trimmingCharacters(in: .whitespacesAndNewlines)
            let description = node.description.trimmingCharacters(in: .whitespacesAndNewlines)
            namesAndViews[name] = description
        }
        return .visitChildren
    }
    
    func getViews() -> [String : String] {
        return namesAndViews
    }
}
