import SwiftSyntax

class ToleranceTimerManager: EnergyVisitable {
    
    private var views: [String] = []
    
    func analyze(_ sourceFile: SourceFileSyntax) {
        let startVisitor = ToleranceTimerStartVisitor(viewMode: .sourceAccurate)
        startVisitor.walk(sourceFile)
        
        let stopVisitor = ToleranceTimerStopVisitor(viewMode: .sourceAccurate)
        stopVisitor.walk(sourceFile)
        
        let startNames = Set(startVisitor.getNames())
        let stopNames = Set(stopVisitor.getNames())

        let unpairedTimers = startNames.subtracting(stopNames)
    
        let filteredViews = startVisitor.getViews().filter { view in
            for name in unpairedTimers {
                if view.hasPrefix("\(name) ") || view.hasPrefix("\(name)=") {
                    return true
                }
            }
            return false
        }
        
        views = filteredViews
        
        if !unpairedTimers.isEmpty {
            print("\nFound absence of Timer tolerance property:")
            views.forEach { print($0) }
        }
        
        let toleranceVisitor = ToleranceParameterVisitor(viewMode: .sourceAccurate)
        toleranceVisitor.walk(sourceFile)
        if !toleranceVisitor.getViews().isEmpty {
            print("\nFound absence of Timer tolerance parameter:")
            toleranceVisitor.getViews().forEach { print($0) }
        }
    }
    
    func getViews() -> [String] {
        views
    }
}
