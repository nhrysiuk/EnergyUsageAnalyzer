import SwiftSyntax

class ShadowPropertyVisitor: SyntaxVisitor {
    
    private var warnings: [WarningMessage] = []
    private let filePath: String
    
    init(filePath: String) {
        self.filePath = filePath
        super.init(viewMode: .all)
    }
    
    override func visit(_ node: SequenceExprSyntax) -> SyntaxVisitorContinueKind {
        if let memberAccess = node.elements.first?.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "shadowOpacity",
           let intLiteral = node.elements.last?.as(IntegerLiteralExprSyntax.self),
           let value = Int(intLiteral.literal.text.trimmingCharacters(in: .whitespacesAndNewlines)),
           value > 0  {
            let location = node.startLocation(converter: SourceLocationConverter(fileName: filePath, tree: node.root))
            let warningMessage = WarningMessage(filePath: filePath, line: location.line, column: location.column, message: "Found shadow usage, consider avoiding it (shadow_rule)")
            
            warnings.append(warningMessage)
        }
        return .visitChildren
    }
    
    func getViews() -> [WarningMessage] {
        warnings
    }
}
