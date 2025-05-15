import Foundation
import SwiftSyntax

class DrawAllocationVisitor: SyntaxVisitor, EnergyVisitable {
    
    func analyze(_ sourceFile: SwiftSyntax.SourceFileSyntax) {
        walk(sourceFile)
    }
    
    private var views: [String] = []
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        if node.modifiers.contains(where: { $0.name.text == "override" }),
           node.name.text == "draw",
           let parameters = node.signature.parameterClause.parameters.first,
           parameters.type.as(IdentifierTypeSyntax.self)?.name.text == "CGRect",
           let statements = node.body?.statements {
            checkEachFunc(for: statements)
        }
        return .visitChildren
    }
    
    private func checkEachFunc(for statements: CodeBlockItemListSyntax) {
        for statement in statements {
            if let _ = statement.item.as(VariableDeclSyntax.self) {
                views.append(statement.description.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }
    
    func getViews() -> [String] {
        return views
    }
}
