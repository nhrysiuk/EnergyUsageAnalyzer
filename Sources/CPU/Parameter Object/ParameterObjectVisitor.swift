import SwiftSyntax

class ParameterObjectVisitor: SyntaxVisitor {
    
    private var views: [WarningMessage] = []
    private let filePath: String
    
    init(filePath: String) {
        self.filePath = filePath
        super.init(viewMode: .all)
    }
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let number = node.signature.parameterClause.parameters.count
        if number > 2 {
            let location = node.startLocation(converter: SourceLocationConverter(fileName: filePath, tree: node.root))
            let warningMessage = WarningMessage(filePath: filePath, line: location.line, column: location.column, message: "Found \(number) arguments, consider introducing a parameter object (parameter_rule)")
            
            views.append(warningMessage)
        }
        
        return .visitChildren
    }
    
    func getViews() -> [WarningMessage] {
        return views
    }
}
