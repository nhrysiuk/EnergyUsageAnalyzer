import SwiftSyntax

class DrawAllocationManager: EnergyVisitable {
    
    private var views: [String] = []
    
    func analyze(_ sourceFile: SourceFileSyntax) {
        let visitor = DrawAllocationVisitor(viewMode: .sourceAccurate)
        visitor.walk(sourceFile)
        
        views = visitor.getViews()
        if !views.isEmpty {
            print("\nFound draw allocations: ")
            views.forEach { print("\($0)") }
        }
    }
    
    func getViews() -> [String] {
        views
    }
}
