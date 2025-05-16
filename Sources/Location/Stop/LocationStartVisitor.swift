import SwiftSyntax

class LocationStartVisitor: SyntaxVisitor {
    
    private enum LocationMethod: String {
        case updating = "startUpdatingLocation"
        case significantChanges = "startMonitoringSignificantLocationChanges"
        case visits = "startMonitoringVisits"
    }
    
    private var managerNames: [LocationMethod:[String]] = [
        .updating: [],
        .significantChanges: [],
        .visits: []
    ]
    
    private var updateViews: [String] = []
    private var significantChangesViews: [String] = []
    private var visitViews: [String] = []
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        guard let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self) else { return .visitChildren }
        switch memberAccess.declName.baseName.text {
        case "startUpdatingLocation":
            guard let managerName = memberAccess.base?.description.trimmingCharacters(in: .whitespacesAndNewlines) else { return .visitChildren}
            managerNames[.updating]?.append(managerName)

            let description = node.description
            if let range = description.range(of: "^[\\s\\n]+", options: .regularExpression) {
                updateViews.append(String(description[range.upperBound...]))
            } else {
                updateViews.append(description)
            }
            
        case "startMonitoringSignificantLocationChanges":
            guard let managerName = memberAccess.base?.description.trimmingCharacters(in: .whitespacesAndNewlines) else { return .visitChildren}
            managerNames[.significantChanges]?.append(managerName)

            let description = node.description
            if let range = description.range(of: "^[\\s\\n]+", options: .regularExpression) {
                significantChangesViews.append(String(description[range.upperBound...]))
            } else {
                significantChangesViews.append(description)
            }
            
        case "startMonitoringVisits":
            guard let managerName = memberAccess.base?.description.trimmingCharacters(in: .whitespacesAndNewlines) else { return .visitChildren}
            managerNames[.visits]?.append(managerName)

            let description = node.description
            if let range = description.range(of: "^[\\s\\n]+", options: .regularExpression) {
                visitViews.append(String(description[range.upperBound...]))
            } else {
                visitViews.append(description)
            }
            
        default:
            return .visitChildren
        }
        
        return .visitChildren
    }
    
    func getUpdateViews() -> [String] {
        return updateViews
    }
    
    func getSignificantChangesViews() -> [String] {
        return significantChangesViews
    }
    
    func getVisitViews() -> [String] {
        return visitViews
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
    
    func hasNames() -> Bool {
        if managerNames[.visits]!.isEmpty && managerNames[.significantChanges]!.isEmpty && managerNames[.updating]!.isEmpty {
            return false
        } else { return true }
    }
    
    func getViews() -> [String] {
        return updateViews + significantChangesViews + visitViews
    }
}
