import SwiftSyntax

class ScheduledTimerCoordinator: EnergyCoordinator {
    
    let identifier = "scheduled_timer_rule"
    
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage] {
        let startVisitor = ScheduledTimerStartVisitor(filePath: filePath)
        startVisitor.walk(sourceFile)
        
        let stopVisitor = ScheduledTimerStopVisitor(viewMode: .sourceAccurate)
        stopVisitor.walk(sourceFile)
        
        let startNames = startVisitor.getViews()
        let stopNames = stopVisitor.getNames()
        
        return startNames.filter { !stopNames.contains($0.0) }.map(\.1)
    }
}
