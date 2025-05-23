import SwiftSyntax

class AlphaPropertyVisitor: SyntaxVisitor {
    
    private var warnings: [WarningMessage] = []
    private let filePath: String
    
    init(filePath: String) {
        self.filePath = filePath
        super.init(viewMode: .all)
    }
    
    override func visit(_ node: SequenceExprSyntax) -> SyntaxVisitorContinueKind {
        if let memberAccess = node.elements.first?.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "alpha",
           let floatLiteral = node.elements.last?.as(FloatLiteralExprSyntax.self),
           let alphaValue = Double(floatLiteral.literal.text),
           alphaValue > 0.0 && alphaValue < 1.0 {
            let location = node.startLocation(converter: SourceLocationConverter(fileName: filePath, tree: node.root))
            let warningMessage = WarningMessage(filePath: filePath, line: location.line, column: location.column, message: "Found opacity usage, consider avoiding it (opacity_rule)")
            
            warnings.append(warningMessage)
        }
        return .visitChildren
    }
    
    func getViews() -> [WarningMessage] {
        warnings
    }
}
