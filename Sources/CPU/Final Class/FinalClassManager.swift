import SwiftSyntax

class FinalClassManager: EnergyVisitable {
    
    private var views: [String] = []
    
    func analyze(_ sourceFile: SourceFileSyntax) {
        let visitor = FinalClassVisitor(viewMode: .sourceAccurate)
        visitor.walk(sourceFile)
        
        if !visitor.getViews().isEmpty {
            print("Found classes that can be final instead: ")
            views.forEach { print("\($0)") }
        }
    }
    
    func getViews() -> [String] {
        views
    }
}
