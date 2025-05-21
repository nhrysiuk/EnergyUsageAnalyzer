import Foundation
import ArgumentParser
import SwiftParser
import SwiftSyntax


@main
struct XcodeAnalyzer: ParsableCommand {
    
    @usableFromInline
    static let configuration: CommandConfiguration = CommandConfiguration(
        commandName: "energy-analyzer",
        abstract: "A tool for analyzing energy usage"
    )
    
    @Option(name: .short, help: "Path to the input file to analyze")
    var inputFilePath: String
    
    
    mutating func run() throws {
        var messages: [WarningMessage] = []
        guard FileManager.default.fileExists(atPath: inputFilePath) else {
            throw ValidationError("File doesn't exist at path: \(inputFilePath)")
        }
        
        guard let file = try? String(contentsOfFile: inputFilePath) else {
            throw ValidationError("File at path isn't readable: \(inputFilePath)")
        }
        
        let sourceFile = Parser.parse(source: file)
        messages = analyzed(file: sourceFile)
        
        let formattedMessages = messages.map { $0.format() }.joined(separator: "\n")
        print(formattedMessages)
    }
    
    private func analyzed(file: SourceFileSyntax) -> [WarningMessage] {
        var result = [[WarningMessage]]()
        
        for visitor in Const().allVisitors {
            result.append(visitor.analyze(file, filePath: inputFilePath))
        }
        
        return result.flatMap { $0 }
    }
    
}

