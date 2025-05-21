import SwiftSyntax

protocol EnergyVisitable {
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage]
}
