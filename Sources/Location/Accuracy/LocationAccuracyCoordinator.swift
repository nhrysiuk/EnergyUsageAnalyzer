import SwiftSyntax
import CoreLocation

class LocationAccuracyCoordinator: EnergyCoordinator {
    
    let identifier = "location_accuracy_rule"
    
    private var views: [String] = []
    
    let inefficientConfigs: [(String, CLLocationDistance)] = [("kCLLocationAccuracyBest", 256),("kCLLocationAccuracyBestForNavigation", 256),("kCLLocationAccuracyBest", 16)]
    
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String)  -> [WarningMessage] {
        let locationManager = LocationStartVisitor(filePath: filePath)
        locationManager.walk(sourceFile)
        
        guard let codeLocation = locationManager.getAllWarnings().first else { return [] }
        
        
        let accuracyVisitor = LocationAccuracyVisitor(filePath: filePath, codePlacement: (codeLocation.line, codeLocation.column))
        accuracyVisitor.walk(sourceFile)
        
        let config = accuracyVisitor.getConfig()
        
        if locationManager.hasNames() &&
            inefficientConfigs.contains (where: { $0 == config }) {
            return [WarningMessage(filePath: filePath, line: accuracyVisitor.getLocation().0, column: accuracyVisitor.getLocation().1, message: "Found inefficient location configs: consider using desiredAccuracy = Kilometer and distanceFilter = 2^8 meters (location_accuracy_rule)")]
        } else { return [] }
    }
    
    func getViews() -> [String] {
        return views
    }
}

