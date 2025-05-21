import SwiftSyntax

class ScheduledTimerStartVisitor: SyntaxVisitor {
    
    private var warnings: [(name: String, warning: WarningMessage)] = []
    private let filePath: String
    
    init(filePath: String) {
        self.filePath = filePath
        super.init(viewMode: .all)
    }
    
    
    override func visit(_ node: SequenceExprSyntax) -> SyntaxVisitorContinueKind {
        if let method = node.elements.last?.as(FunctionCallExprSyntax.self),
           let memberAccess = method.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "scheduledTimer" {
            
            if let declReference = node.elements.first?.as(DeclReferenceExprSyntax.self) {
                let location = node.startLocation(converter: SourceLocationConverter(fileName: filePath, tree: node.root))
                
                warnings.append((declReference.baseName.text,
                                 WarningMessage(filePath: filePath, line: location.line, column: location.column, message: "Found Timer named \(declReference.baseName.text) that doesn't stop")))
            }
        }
        return .visitChildren
    }
    
    func getViews() -> [(name: String, warning: WarningMessage)] {
        return warnings
    }
}
