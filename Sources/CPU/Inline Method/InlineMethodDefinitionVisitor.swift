import Foundation
import SwiftSyntax

class InlineMethodDefinitionVisitor: SyntaxVisitor {
    
    private var names = [String]()
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
            names.append(node.name.text.trimmingCharacters(in: .whitespacesAndNewlines))
        return .visitChildren
    }

    func getNames() -> [String] {
        return names
    }
}
