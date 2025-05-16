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
            if let dotIndex = view.firstIndex(of: ".") {
                let managerName = String(view.prefix(upTo: dotIndex))
                return unpairedTimers.contains(managerName)
            }
            return true
        }
        
        views = filteredViews
        
        
        if !unpairedTimers.isEmpty {
            print("Found absence of Timer tolerance:")
            unpairedTimers.forEach { print($0) }
        }
        
        let toleranceVisitor = ToleranceParameterVisitor(viewMode: .sourceAccurate)
        toleranceVisitor.walk(sourceFile)
        if !toleranceVisitor.getViews().isEmpty {
            print("Found absence of Timer tolerance:")
            toleranceVisitor.getViews().forEach { print($0) }
        }
    }
    
    func getViews() -> [String] {
        views
    }
}
