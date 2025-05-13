// The Swift Programming Language
// https://docs.swift.org/swift-book
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
        let visitor = ShadowPropertyVisitor(viewMode: .sourceAccurate)
        visitor.walk(sourceFile)
        
        let views = visitor.getViews()
        if views.isEmpty {
            print("No opacity modifiers found in the file.")
        } else {
            print("Found opacity modifiers:")
            views.forEach { print($0) }
        }
    }
}

EnergyUsageAnalyzer.main()
