import SwiftSyntax

protocol EnergyRule {
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage]
    
    var identifier: String { get }
}
