import Foundation
import SwiftSyntax

class InstanceFunctionsManager: EnergyVisitable {
    
    private var views: [String] = []
    
    func analyze(_ sourceFile: SourceFileSyntax) {
        let funcVisitor = InstanceFunctionsVisitor(viewMode: .sourceAccurate)
        funcVisitor.walk(sourceFile)
        
        let propertiesVisitor = InstancePropertiesVisitor(viewMode: .sourceAccurate)
        propertiesVisitor.walk(sourceFile)
        
        var codeBlocks = funcVisitor.getCodeBlocks()
        let propertyNames = propertiesVisitor.getNames()

        for name in propertyNames {
            codeBlocks = codeBlocks.filter { !$0.key.contains(name) }
        }
        
        views = codeBlocks.map { $0.value }
        
        if !views.isEmpty {
            print("\nFound functions that can be static: ")
            views.forEach { print("\($0)") }
        }
    }
    
    func getViews() -> [String] {
        views
    }
}
