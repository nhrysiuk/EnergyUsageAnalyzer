import SwiftSyntax

class PublishTimerManager: EnergyVisitable {
    
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage] {
        let startVisitor = PublishTimerStartVisitor(filePath: filePath)
        startVisitor.walk(sourceFile)
        
        let stopVisitor = PublishTimerStopVisitor(viewMode: .sourceAccurate)
        stopVisitor.walk(sourceFile)
        
        let startNames = startVisitor.getViews()
        let stopNames = stopVisitor.getNames()
        
        return startNames.filter { !stopNames.contains($0.0) }.map(\.1)
    }
}
