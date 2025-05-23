import SwiftSyntax

class ToleranceParameterVisitor: SyntaxVisitor {
    
    private var warnings: [WarningMessage] = []
    private let filePath: String
    
    init(filePath: String) {
        self.filePath = filePath
        super.init(viewMode: .all)
    }
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        guard let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self),
              memberAccess.declName.baseName.text == "publish",
              let base = memberAccess.base?.as(DeclReferenceExprSyntax.self),
              base.baseName.text == "Timer" else {
            return .visitChildren
        }
        
        let hasToleranceParameter = node.arguments.contains { argument in
            argument.label?.text == "tolerance"
        }
        
        if !hasToleranceParameter {
            let location = node.startLocation(converter: SourceLocationConverter(fileName: filePath, tree: node.root))
            
            warnings.append(WarningMessage(filePath: filePath,
                                           line: location.line,
                                           column: location.column,
                                           message: "Found Timer that has no tolerance (tolerance_rule)"))
        }
        
        return .visitChildren
    }
    
    func getViews() -> [WarningMessage] {
        return warnings
    }
}
