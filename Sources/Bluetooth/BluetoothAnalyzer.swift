import Foundation
import SwiftSyntax

class BluetoothAnalyzer: EnergyAnalyzer {
    
    let identifier = "bluetooth_rule"
    
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage] {

        let startVisitor = BluetoothStartVisitor(filePath: filePath)
        startVisitor.walk(sourceFile)
        
        let stopVisitor = BluetoothStopVisitor(viewMode: .sourceAccurate)
        stopVisitor.walk(sourceFile)
        
        let startNames = startVisitor.getViews()
        let stopNames = stopVisitor.getNames()

        let names = startNames.filter { !stopNames.contains($0.key) }
                                                 
        return names.map {$0.value}
    }
}
