import Foundation
import SwiftSyntax

class BluetoothManager: EnergyVisitable {
    
    private var views: [String] = []
    
    func analyze(_ sourceFile: SourceFileSyntax) {
        let startVisitor = BluetoothStartVisitor(viewMode: .sourceAccurate)
        startVisitor.walk(sourceFile)
        
        let stopVisitor = BluetoothStopVisitor(viewMode: .sourceAccurate)
        stopVisitor.walk(sourceFile)
        
        let startNames = Set(startVisitor.getNames())
        let stopNames = Set(stopVisitor.getNames())

        let unpairedManagers = startNames.subtracting(stopNames)
        
        let filteredViews = startVisitor.getViews().filter { view in
            if let dotIndex = view.firstIndex(of: ".") {
                let managerName = String(view.prefix(upTo: dotIndex))
                return unpairedManagers.contains(managerName)
            }
            return true
        }
        
        views = filteredViews
        
        if !unpairedManagers.isEmpty {
            print("Found managers that start scanning but don't stop:")
            unpairedManagers.forEach { print($0) }
        }
    }
    
    func getViews() -> [String] {
        views
    }
}
