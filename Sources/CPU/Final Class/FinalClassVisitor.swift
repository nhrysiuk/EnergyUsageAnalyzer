import Foundation
import SwiftSyntax

class FinalClassVisitor: SyntaxVisitor {
    
    private var views: [WarningMessage] = []
    private let filePath: String
    
     init(filePath: String) {
         self.filePath = filePath
         super.init(viewMode: .all)
     }
    
    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        if !node.modifiers.contains(where: { $0.name.text == "final" }) {
            let location = node.startLocation(converter: SourceLocationConverter(fileName: filePath, tree: node.root))
            let warningMessage = WarningMessage(filePath: filePath, line: location.line, column: location.column, message: "Make this class final if possible")
            
            views.append(warningMessage)
        }
        return .visitChildren
    }
    
    func getViews() -> [WarningMessage] {
        return views
    }
}
