import Foundation
import SwiftSyntax

class InstanceFunctionsVisitor: SyntaxVisitor, EnergyVisitable {
    
    func analyze(_ sourceFile: SwiftSyntax.SourceFileSyntax) {
        walk(sourceFile)
    }
    
    private var codeBlocks = [String : String]()
    
    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let members = node.memberBlock.members
        search(members: members)
        
        return .visitChildren
    }
    
    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        let members = node.memberBlock.members
        search(members: members)

        return .visitChildren
    }
    
    func search(members: MemberBlockItemListSyntax) {
        for member in members {
            if let funcDecl = member.decl.as(FunctionDeclSyntax.self) {
                if let bodyContent = funcDecl.body?.description,
                   funcDecl.modifiers.isEmpty{
                    codeBlocks[bodyContent.trimmingCharacters(in: .whitespacesAndNewlines)] = funcDecl.description.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
        }
    }
    
    
    func getCodeBlocks() -> [String : String] {
        return codeBlocks
    }
}
