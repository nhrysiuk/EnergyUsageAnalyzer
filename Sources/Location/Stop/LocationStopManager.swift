import SwiftSyntax

class LocationStopManager: EnergyVisitable {
    
    private var views: [String] = []
    
    func analyze(_ sourceFile: SourceFileSyntax) {
        let startVisitor = LocationStartVisitor(viewMode: .sourceAccurate)
        startVisitor.walk(sourceFile)
        
        let stopVisitor = LocationStopVisitor(viewMode: .sourceAccurate)
        stopVisitor.walk(sourceFile)
        
        let unpairedUpdateManagers = Set(startVisitor.getUpdateNames()).subtracting(Set(stopVisitor.getUpdateNames()))
        let unpairedSignificantManagers = Set(startVisitor.getSignificantChangesNames()).subtracting(Set(stopVisitor.getSignificantChangesNames()))
        let unpairedVisitManagers = Set(startVisitor.getVisitNames()).subtracting(Set(stopVisitor.getVisitNames()))
        
        let filteredUpdateViews = startVisitor.getUpdateViews().filter { view in
            if let dotIndex = view.firstIndex(of: ".") {
                let managerName = String(view.prefix(upTo: dotIndex))
                return unpairedUpdateManagers.contains(managerName)
            }
            return true
        }
        
        let filteredSignificantViews = startVisitor.getSignificantChangesViews().filter { view in
            if let dotIndex = view.firstIndex(of: ".") {
                let managerName = String(view.prefix(upTo: dotIndex))
                return unpairedUpdateManagers.contains(managerName)
            }
            return true
        }
        
        let filteredVisitViews = startVisitor.getVisitViews().filter { view in
            if let dotIndex = view.firstIndex(of: ".") {
                let managerName = String(view.prefix(upTo: dotIndex))
                return unpairedUpdateManagers.contains(managerName)
            }
            return true
        }
        
        if !unpairedUpdateManagers.isEmpty || !unpairedSignificantManagers.isEmpty || !unpairedVisitManagers.isEmpty {
            print("Found managers that start scanning location but don't stop:")
            filteredUpdateViews.forEach { print($0) }
            print("\n")
            filteredSignificantViews.forEach { print($0) }
            print("\n")
            filteredVisitViews.forEach { print($0) }
        }
    }
    
    func getViews() -> [String] {
        views
    }
}
