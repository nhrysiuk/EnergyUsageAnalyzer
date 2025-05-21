import Foundation
import SwiftSyntax

class InstancePropertiesVisitor: SyntaxVisitor {
    
    private var names = [String]()

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let members = node.memberBlock.members
        
        for member in members {
            checkMemberBlockItem(member)
        }

        return .visitChildren
    }

    func checkMemberBlockItem(_ block: MemberBlockItemSyntax) {
        if let variable = block.decl.as(VariableDeclSyntax.self) {
            for x in variable.modifiers {
                if x.name.text == "static" {
                    return
                }
            }
            
            if let name = variable.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text {
                names.append(" \(name) ")
                names.append("\n\(name) ")
                names.append("\n\(name)\n")
                names.append(" \(name)\n")
                names.append(" \(name).")
                names.append("\n\(name).")
                names.append("self.\(name).")
            }
        }
    }

    func getNames() -> [String] {
        return names
    }
}
