import SwiftSyntax

class PublishTimerStartVisitor: SyntaxVisitor {
    
    private var warnings: [(name: String, warning: WarningMessage)] = []
    private let filePath: String
    
    init(filePath: String) {
        self.filePath = filePath
        super.init(viewMode: .all)
    }
    
    override func visit(_ node: SequenceExprSyntax) -> SyntaxVisitorContinueKind {
        if let method = node.elements.last?.as(FunctionCallExprSyntax.self),
           let memberAccess1 = method.calledExpression.as(MemberAccessExprSyntax.self),
           let base1 = memberAccess1.base?.as(FunctionCallExprSyntax.self),
           let memberAccess2 = base1.calledExpression.as(MemberAccessExprSyntax.self),
           let base2 = memberAccess2.base?.as(FunctionCallExprSyntax.self),
           let memberAccess3 = base2.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess3.base?.as(DeclReferenceExprSyntax.self)?.baseName.text == "Timer",
           memberAccess3.declName.baseName.text == "publish",
           let declReference = node.elements.first?.as(DeclReferenceExprSyntax.self) {
            
            let location = node.startLocation(converter: SourceLocationConverter(fileName: filePath, tree: node.root))
            
            warnings.append((declReference.baseName.text,
                             WarningMessage(filePath: filePath, line: location.line, column: location.column, message: "Found Timer named \(declReference.baseName.text)  that doesn't stop")))
        }
        
        return .visitChildren
    }
    
    func getViews() -> [(name: String, warning: WarningMessage)]  {
        warnings
    }
}
