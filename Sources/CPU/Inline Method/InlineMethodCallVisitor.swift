import Foundation
import SwiftSyntax

class InlineMethodCallVisitor: SyntaxVisitor {
    
    private var namesAndViews = [(String, String, WarningMessage)]()
    private let filePath: String
    
    init(filePath: String) {
        self.filePath = filePath
        super.init(viewMode: .all)
    }
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        if let body = node.body,
           body.statements.count == 1,
           let statement = body.statements.first,
           let functionCall = statement.item.as(FunctionCallExprSyntax.self),
           let expression = functionCall.calledExpression.as(DeclReferenceExprSyntax.self) {
            let name = expression.baseName.text.trimmingCharacters(in: .whitespacesAndNewlines)
            let description = node.description.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let location = node.startLocation(converter: SourceLocationConverter(fileName: filePath, tree: node.root))
            let warningMessage = WarningMessage(filePath: filePath, line: location.line, column: location.column, message: "Found inline method, consider refactoring (inline_method_rule)")
            
            namesAndViews.append((name, description, warningMessage))
        }
        
        return .visitChildren
    }
    
    func getViews() ->  [(String, String, WarningMessage)] {
        return namesAndViews
    }
}
