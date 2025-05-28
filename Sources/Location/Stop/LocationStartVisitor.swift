import SwiftSyntax

class LocationStartVisitor: SyntaxVisitor {
    
    private var views: [WarningMessage] = []
    private let filePath: String
    
    init(filePath: String) {
        self.filePath = filePath
        super.init(viewMode: .all)
    }
    
    private enum LocationMethod: String {
        case updating = "startUpdatingLocation"
        case significantChanges = "startMonitoringSignificantLocationChanges"
        case visits = "startMonitoringVisits"
    }
    
    private var managerNames: [LocationMethod:[(String, WarningMessage)]] = [
        .updating: [],
        .significantChanges: [],
        .visits: []
    ]
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        guard let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self) else { return .visitChildren }
        
        let location = node.startLocation(converter: SourceLocationConverter(fileName: filePath, tree: node.root))
        let warningMessage = WarningMessage(filePath: filePath, line: location.line, column: location.column, message: "Found location start call without a corresponding stop. Make sure to stop it when it's no longer needed (location_scanning_rule)")
        
        switch memberAccess.declName.baseName.text {
        case "startUpdatingLocation":
            guard let managerName = memberAccess.base?.description.trimmingCharacters(in: .whitespacesAndNewlines) else { return .visitChildren}
            managerNames[.updating]?.append((managerName, warningMessage))
            
        case "startMonitoringSignificantLocationChanges":
            guard let managerName = memberAccess.base?.description.trimmingCharacters(in: .whitespacesAndNewlines) else { return .visitChildren}
            managerNames[.significantChanges]?.append((managerName, warningMessage))
            
        case "startMonitoringVisits":
            guard let managerName = memberAccess.base?.description.trimmingCharacters(in: .whitespacesAndNewlines) else { return .visitChildren}
            managerNames[.visits]?.append((managerName, warningMessage))
            
        default:
            return .visitChildren
        }
        
        return .visitChildren
    }
    
    func getUpdateNames() -> [(String, WarningMessage)] {
        return managerNames[.updating, default: []]
    }
    
    func getSignificantChangesNames() -> [(String, WarningMessage)] {
        return managerNames[.significantChanges, default: []]
    }
    
    func getVisitNames() -> [(String, WarningMessage)] {
        return managerNames[.visits, default: []]
    }
    
    func getAllWarnings() -> [WarningMessage] {
        let a = getUpdateNames()
        let b = getSignificantChangesNames()
        let c = getVisitNames()
        let allNames = a + b + c
        return allNames.map { $0.1 }
    }
    
    func hasNames() -> Bool {
        managerNames[.visits]!.isEmpty || managerNames[.significantChanges]!.isEmpty || managerNames[.updating]!.isEmpty
    }
}
