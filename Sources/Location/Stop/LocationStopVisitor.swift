import Foundation
import SwiftSyntax

class LocationStopVisitor: SyntaxVisitor {
    
    private enum LocationMethod: String {
        case updating = "stopUpdatingLocation"
        case significantChanges = "stopMonitoringSignificantLocationChanges"
        case visits = "stopMonitoringVisits"
    }
    
    private var managerNames: [LocationMethod:[String]] = [
        .updating: [],
        .significantChanges: [],
        .visits: []
    ]
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        guard let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self),
              let method = LocationMethod(rawValue: memberAccess.declName.baseName.text),
              let managerName = memberAccess.base?.description.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return .visitChildren
        }
        
        managerNames[method]?.append(managerName)
        return .visitChildren
    }
    
    func getUpdateNames() -> [String] {
        return managerNames[.updating] ?? []
    }
    
    func getSignificantChangesNames() -> [String] {
        return managerNames[.significantChanges] ?? []
    }
    
    func getVisitNames() -> [String] {
        return managerNames[.visits] ?? []
    }
}
