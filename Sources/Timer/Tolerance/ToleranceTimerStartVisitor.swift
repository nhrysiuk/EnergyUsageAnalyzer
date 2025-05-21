import SwiftSyntax

class ToleranceTimerStartVisitor: SyntaxVisitor {
    
    private var warnings: [(name: String, warning: WarningMessage)] = []
    private let filePath: String
    
    init(filePath: String) {
        self.filePath = filePath
        super.init(viewMode: .all)
    }
    
    override func visit(_ node: SequenceExprSyntax) -> SyntaxVisitorContinueKind {
        if let funcCall = node.elements.last?.as(FunctionCallExprSyntax.self),
           let type = funcCall.calledExpression.as(DeclReferenceExprSyntax.self),
           type.baseName.text == "Timer",
           let firstArg = funcCall.arguments.first,
           let secondArg = funcCall.arguments.dropFirst().first,
           firstArg.label?.text == "timeInterval",
           secondArg.label?.text == "repeats",
           let declReference = node.elements.first?.as(DeclReferenceExprSyntax.self) {
            
            let location = node.startLocation(converter: SourceLocationConverter(fileName: filePath, tree: node.root))
            
            warnings.append((declReference.baseName.text,
                             WarningMessage(filePath: filePath, line: location.line, column: location.column, message: "Found Timer that has no tolerance property")))
        }
        return .visitChildren
    }
    
    func getViews() -> [(name: String, warning: WarningMessage)] {
        return warnings
    }
}
