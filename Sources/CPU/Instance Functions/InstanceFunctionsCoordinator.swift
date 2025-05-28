import Foundation
import SwiftSyntax

class InstanceFunctionsCoordinator: EnergyCoordinator {
    
    let identifier = "instance_identifier_rule"
    
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage] {
        let funcVisitor = InstanceFunctionsVisitor(filePath: filePath)
        funcVisitor.walk(sourceFile)
        
        let propertiesVisitor = InstancePropertiesVisitor(viewMode: .sourceAccurate)
        propertiesVisitor.walk(sourceFile)
        
        var codeBlocks = funcVisitor.getCodeBlocks()
        let propertyNames = propertiesVisitor.getNames()
        
        for name in propertyNames {
            codeBlocks = codeBlocks.filter { !$0.0.contains(name) }
        }
        
        return codeBlocks.map { $0.2 }
    }
}
