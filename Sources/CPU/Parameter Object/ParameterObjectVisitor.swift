import SwiftSyntax

class ParameterObjectVisitor: SyntaxVisitor {
    
    private var views: [String] = []
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        if node.signature.parameterClause.parameters.count > 2 {
            print(node.description.trimmingCharacters(in: .whitespacesAndNewlines) )
            views.append(node.description)
        }
        return .visitChildren
    }
    
    func getViews() -> [String] {
        return views
    }
}
