import SwiftSyntax

class ToleranceTimerStartVisitor: SyntaxVisitor {
    
    private var names: [String] = []
    private var views: [String] = []
    
    override func visit(_ node: SequenceExprSyntax) -> SyntaxVisitorContinueKind {
        if let funcCall = node.elements.last?.as(FunctionCallExprSyntax.self),
           let type = funcCall.calledExpression.as(DeclReferenceExprSyntax.self),
           type.baseName.text == "Timer",
           let firstArg = funcCall.arguments.first,
           let secondArg = funcCall.arguments.dropFirst().first,
           firstArg.label?.text == "timeInterval",
           secondArg.label?.text == "repeats",
           let declReference = node.elements.first?.as(DeclReferenceExprSyntax.self) {
            names.append(declReference.baseName.text)
            views.append(node.description)
        }
        return .visitChildren
    }
    
    func getViews() -> [String] {
        return views
    }
    
    func getNames() -> [String] {
        return names
    }
}
