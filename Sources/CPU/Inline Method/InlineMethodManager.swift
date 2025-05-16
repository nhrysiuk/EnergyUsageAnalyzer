import Foundation
import SwiftSyntax

class InlineMethodManager: EnergyVisitable {
    
    private var views: [String] = []
    
    func analyze(_ sourceFile: SourceFileSyntax) {
        let callVisitor = InlineMethodCallVisitor(viewMode: .sourceAccurate)
        callVisitor.walk(sourceFile)
        
        let definitionVisitor = InlineMethodDefinitionVisitor(viewMode: .sourceAccurate)
        definitionVisitor.walk(sourceFile)
        
        let callNames = callVisitor.getViews()
        let defNames = definitionVisitor.getNames()
        
        views = callNames.filter { defNames.contains($0.key) }.map { $0.value }
        
        if !views.isEmpty {
            print("\nFound inline methods: ")
            views.forEach { print("\($0)") }
        }
    }
    
    func getViews() -> [String] {
        views
    }
}
