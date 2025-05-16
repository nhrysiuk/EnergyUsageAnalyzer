import Foundation
import SwiftSyntax

class InstanceFunctionsVisitor: SyntaxVisitor, EnergyVisitable {
    
    func analyze(_ sourceFile: SwiftSyntax.SourceFileSyntax) {
        walk(sourceFile)
    }
    
    private var codeBlocks = [String : String]()
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        if let bodyContent = node.body?.description,
           node.modifiers.isEmpty{
            codeBlocks[bodyContent] = node.description.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return .visitChildren
    }
    
    func getCodeBlocks() -> [String : String] {
        return codeBlocks
    }
}
