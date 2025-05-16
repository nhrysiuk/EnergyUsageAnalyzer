import SwiftSyntax
import CoreLocation

class LocationAccuracyManager: EnergyVisitable {
    
    private var views: [String] = []
    
    let inefficientConfigs: [(String, CLLocationDistance)] = [("kCLLocationAccuracyBest", 256),("kCLLocationAccuracyBestForNavigation", 256),("kCLLocationAccuracyBest", 16)]
    
    func analyze(_ sourceFile: SourceFileSyntax) {
        let locationManager = LocationStartVisitor(viewMode: .sourceAccurate)
        locationManager.walk(sourceFile)
        
        let startVisitor = LocationAccuracyVisitor(viewMode: .sourceAccurate)
        startVisitor.walk(sourceFile)
        
        let config = startVisitor.getConfig()
        
        if locationManager.hasNames() && inefficientConfigs.contains (where: { x in
            x == config
        }) {
            print("Found inefficient location accuracy configuration:")
            print("- Accuracy Level: \(config.accuracyLevel)")
            print("- Distance Filter: \(config.distance)")
            views = startVisitor.getViews()
            if views.isEmpty {
                print(locationManager.getViews())
            } else {
                print(views)
            }
        }
    }
    
    func getViews() -> [String] {
        return views
    }
}
