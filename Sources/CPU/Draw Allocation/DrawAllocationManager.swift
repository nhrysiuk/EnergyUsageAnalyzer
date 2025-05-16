import SwiftSyntax

class DrawAllocationManager: EnergyVisitable {
    
    private var views: [String] = []
    
    func analyze(_ sourceFile: SourceFileSyntax) {
        let visitor = DrawAllocationVisitor(viewMode: .sourceAccurate)
        visitor.walk(sourceFile)
        
        if !visitor.getViews().isEmpty {
            print("\nFound draw alloctions: ")
            views.forEach { print("\($0)") }
        }
    }
    
    func getViews() -> [String] {
        views
    }
}
