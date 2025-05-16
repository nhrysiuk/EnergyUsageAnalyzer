import SwiftSyntax

class PublishTimerManager: EnergyVisitable {
    
    private var views: [String] = []
    
    func analyze(_ sourceFile: SourceFileSyntax) {
        let startVisitor = PublishTimerStartVisitor(viewMode: .sourceAccurate)
        startVisitor.walk(sourceFile)
        
        let stopVisitor = PublishTimerStopVisitor(viewMode: .sourceAccurate)
        stopVisitor.walk(sourceFile)
        
        let startNames = Set(startVisitor.getNames())
        let stopNames = Set(stopVisitor.getNames())
        
        let unpairedTimers = startNames.subtracting(stopNames)
        
        let filteredViews = startVisitor.getViews().filter { view in
            for name in unpairedTimers {
                if view.hasPrefix(name) {
                    return true
                }
            }
            return false
        }
        
        views = filteredViews
  
        if !unpairedTimers.isEmpty {
            print("\nFound publish timers that don't stop:")
            views.forEach { print($0) }
        }
    }
    
    func getViews() -> [String] {
        views
    }
}
