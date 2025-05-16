import SwiftSyntax

class FinalClassVisitor: SyntaxVisitor {
    
    private var views: [String] = []
    
    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        if !node.modifiers.contains(where: { $0.name.text == "final" }) {
            print(node.description.trimmingCharacters(in: .whitespacesAndNewlines) )
            views.append(node.description)
        }
        return .visitChildren
    }
    
    func getViews() -> [String] {
        return views
    }
}
