import Foundation
import SwiftSyntax

class InstanceFunctionsVisitor: SyntaxVisitor {
    
    private var codeBlocks = [(String, String, WarningMessage)]()
    private let filePath: String
    
    init(filePath: String) {
        self.filePath = filePath
        super.init(viewMode: .all)
    }
    
    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let location = node.startLocation(converter: SourceLocationConverter(fileName: filePath, tree: node.root))
        let members = node.memberBlock.members
        search(members, location)
        
        return .visitChildren
    }
    
    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        let location = node.startLocation(converter: SourceLocationConverter(fileName: filePath, tree: node.root))
        let members = node.memberBlock.members
        search(members, location)

        return .visitChildren
    }
    
    func search(_ members: MemberBlockItemListSyntax, _ location: SourceLocation) {
        for member in members {
            if let funcDecl = member.decl.as(FunctionDeclSyntax.self) {
                if let bodyContent = funcDecl.body?.description,
                   funcDecl.modifiers.isEmpty {
                    let warningMessage = WarningMessage(filePath: filePath, line: location.line, column: location.column, message: "Found functions that can be static (instance_identifier_rule)")
                    codeBlocks.append((bodyContent.trimmingCharacters(in: .whitespacesAndNewlines),  funcDecl.description.trimmingCharacters(in: .whitespacesAndNewlines), warningMessage))
                }
            }
        }
    }
    
    func getCodeBlocks() -> [(String, String, WarningMessage)] {
        return codeBlocks
    }
}
