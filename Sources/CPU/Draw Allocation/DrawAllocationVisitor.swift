import SwiftSyntax

class DrawAllocationVisitor: SyntaxVisitor {
    
    private var views: [WarningMessage] = []
    private let filePath: String
    
    init(filePath: String) {
        self.filePath = filePath
        super.init(viewMode: .all)
    }
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        if node.modifiers.contains(where: { $0.name.text == "override" }),
           node.name.text == "draw",
           let parameters = node.signature.parameterClause.parameters.first,
           parameters.type.as(IdentifierTypeSyntax.self)?.name.text == "CGRect",
           let statements = node.body?.statements {
            checkEachFunc(for: statements, node: node)
        }
        return .visitChildren
    }
    
    private func checkEachFunc(for statements: CodeBlockItemListSyntax, node: FunctionDeclSyntax) {
        for statement in statements {
            if let _ = statement.item.as(VariableDeclSyntax.self) {
                let location = node.startLocation(converter: SourceLocationConverter(fileName: filePath, tree: node.root))
                let warningMessage = WarningMessage(filePath: filePath, line: location.line, column: location.column, message: "Found draw allocation, move object initialization from draw method if possible")
                
                views.append(warningMessage)
            }
        }
    }
    
    func getViews() -> [WarningMessage] {
        return views
    }
}
