import Foundation
import ArgumentParser
import SwiftSyntax
import SwiftParser

struct EnergyUsageAnalyzer: ParsableCommand {
    
    @usableFromInline
    static let configuration: CommandConfiguration = CommandConfiguration(
        commandName: "energy-analyzer",
        abstract: "A tool for analyzing energy usage"
    )
    
    @Argument(help: "The path to the Swift file to analyze")
    var filePath: String
    
    mutating func run() throws {
        guard FileManager.default.fileExists(atPath: filePath) else {
            throw ValidationError("File doesn't exist at path: \(filePath)")
        }
        
        guard let file = try? String(contentsOfFile: filePath) else {
            throw ValidationError("File at path isn't readable: \(filePath)")
        }
        
        let sourceFile = Parser.parse(source: file)
        analyze(file: sourceFile)
    }
    
    private func analyze(file: SourceFileSyntax) {
        for visitor in Const().visitors {
            visitor.analyze(file)
        }
        
        print("Analysis is done.")
    }
}

EnergyUsageAnalyzer.main()
