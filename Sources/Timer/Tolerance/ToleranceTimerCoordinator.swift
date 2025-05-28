import SwiftSyntax

class ToleranceTimerCoordinator: EnergyCoordinator {
    
    let identifier = "tolerance_rule"
    
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage] {
        let startVisitor = ToleranceTimerStartVisitor(filePath: filePath)
        startVisitor.walk(sourceFile)
        
        let stopVisitor = ToleranceTimerStopVisitor(viewMode: .sourceAccurate)
        stopVisitor.walk(sourceFile)
        
        let startNames = startVisitor.getViews()
        let stopNames = stopVisitor.getNames()
        
        let returnNames = startNames.filter { !stopNames.contains($0.0) }.map(\.1)
        
        let toleranceVisitor = ToleranceParameterVisitor(filePath: filePath)
        toleranceVisitor.walk(sourceFile)
        
        return returnNames + toleranceVisitor.getViews()
    }
}
