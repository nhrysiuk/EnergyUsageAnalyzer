import SwiftSyntax

class BlurModifierVisitor: SyntaxVisitor {
    
    private var views: [WarningMessage] = []
    private let filePath: String
    
    init(filePath: String) {
        self.filePath = filePath
        super.init(viewMode: .all)
    }
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        if let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "blur" {
            
            let location = memberAccess.startLocation(converter: SourceLocationConverter(fileName: filePath, tree: memberAccess.root))
            let warningMessage = WarningMessage(filePath: filePath, line: location.line, column: location.column, message: "Found blur, consider avoiding it (blur_rule)")
            
            views.append(warningMessage)
        }
        return .visitChildren
    }
    
    func getViews() -> [WarningMessage] {
        return views
    }
}
