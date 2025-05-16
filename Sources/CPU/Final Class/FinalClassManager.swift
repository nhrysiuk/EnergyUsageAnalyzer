import SwiftSyntax

class FinalClassManager: EnergyVisitable {
    
    private var views: [String] = []
    
    func analyze(_ sourceFile: SourceFileSyntax) {
        let visitor = FinalClassVisitor(viewMode: .sourceAccurate)
        visitor.walk(sourceFile)
        
        views = visitor.getViews()
        
        if !views.isEmpty {
            print("\nFound classes that can be final instead: ")
            views.forEach { print("\($0)") }
        }
    }
    
    func getViews() -> [String] {
        views
    }
}
