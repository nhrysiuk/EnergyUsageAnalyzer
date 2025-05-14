import Foundation
import SwiftSyntax

class BluetoothStartVisitor: SyntaxVisitor, EnergyVisitable {
    
    func analyze(_ sourceFile: SwiftSyntax.SourceFileSyntax) {
        walk(sourceFile)
    }
    
    private var managerNames: [String] = []
    private var views: [String] = []
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        if let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "scanForPeripherals",
           let managerName = memberAccess.base?.description.trimmingCharacters(in: .whitespacesAndNewlines) {
            managerNames.append(managerName)
            
            let description = node.description
            if let range = description.range(of: "^[\\s\\n]+", options: .regularExpression) {
                views.append(String(description[range.upperBound...]))
            } else {
                views.append(description)
            }
        }
        return .visitChildren
    }
    
    func getViews() -> [String] {
        return views
    }
    
    func getNames() -> [String] {
        return managerNames
    }
}
