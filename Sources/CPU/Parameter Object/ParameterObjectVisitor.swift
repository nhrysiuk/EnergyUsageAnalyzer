import SwiftSyntax

class ParameterObjectVisitor: SyntaxVisitor {
    
    private var views: [String] = []
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        if node.signature.parameterClause.parameters.count > 2 {
            views.append(node.description.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    
        return .visitChildren
    }
    
    func getViews() -> [String] {
        return views
    }
}
