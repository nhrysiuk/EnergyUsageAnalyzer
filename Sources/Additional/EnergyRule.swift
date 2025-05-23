import SwiftSyntax

protocol EnergyAnalyzer {
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage]
    
    var identifier: String { get }
}
