import SwiftSyntax

class LocationStopManager: EnergyVisitable {
    
    private var views: [String] = []
    
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage] {
        let startVisitor = LocationStartVisitor(filePath: filePath)
        startVisitor.walk(sourceFile)
        
        let stopVisitor = LocationStopVisitor(viewMode: .sourceAccurate)
        stopVisitor.walk(sourceFile)

        let unpairedUpdateManagers = startVisitor.getUpdateNames().filter { !stopVisitor.getUpdateNames().contains($0.0) }.map(\.1)
        
        let unpairedSignificantManagers = startVisitor.getSignificantChangesNames().filter { !stopVisitor.getSignificantChangesNames().contains($0.0) }.map(\.1)
        
        let unpairedVisitManagers = startVisitor.getVisitNames().filter { !stopVisitor.getVisitNames().contains($0.0) }.map(\.1)
        
        return unpairedUpdateManagers + unpairedSignificantManagers + unpairedVisitManagers
    }
}
