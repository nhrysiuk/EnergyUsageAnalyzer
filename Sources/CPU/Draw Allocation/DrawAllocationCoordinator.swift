import SwiftSyntax

class DrawAllocationCoordinator: EnergyCoordinator {
    
    let identifier = "draw_allocation_rule"
    
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage] {
        let visitor = DrawAllocationVisitor(filePath: filePath)
        visitor.walk(sourceFile)
        
        return visitor.getViews()
    }
}
