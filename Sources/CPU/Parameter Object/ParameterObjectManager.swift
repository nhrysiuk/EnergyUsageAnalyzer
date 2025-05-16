import SwiftSyntax

class ParameterObjectManager: EnergyVisitable {
    
    private var views: [String] = []
    
    func analyze(_ sourceFile: SourceFileSyntax) {
        let visitor = ParameterObjectVisitor(viewMode: .sourceAccurate)
        visitor.walk(sourceFile)
        
        if !visitor.getViews().isEmpty {
            print("Found possible parameter objects: ")
            views.forEach { print("\($0)") }
        }
    }
    
    func getViews() -> [String] {
        views
    }
}
