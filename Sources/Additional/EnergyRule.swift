import SwiftSyntax

protocol EnergyCoordinator {
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage]
    
    var identifier: String { get }
}
