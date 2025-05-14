import Foundation
import SwiftSyntax

class ScheduledTimerManager: EnergyVisitable {
    
    private var views: [String] = []
    
    func analyze(_ sourceFile: SourceFileSyntax) {
        let startVisitor = PublishTimerStartVisitor(viewMode: .sourceAccurate)
        startVisitor.walk(sourceFile)
        
        let stopVisitor = PublishTimerStopVisitor(viewMode: .sourceAccurate)
        stopVisitor.walk(sourceFile)
        
        let startNames = Set(startVisitor.getNames())
        let stopNames = Set(stopVisitor.getNames())

        print(startNames)
        print(stopNames)
        
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
            print("Found timers that don't stop:")
            unpairedTimers.forEach { print($0) }
        }
    }
    
    func getViews() -> [String] {
        views
    }
}
