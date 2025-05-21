import PackagePlugin
import Foundation

@main
struct EnergyUsageAnalyzerPlugin: BuildToolPlugin {
    func createBuildCommands(
        context: PluginContext,
        target: Target
    ) throws -> [Command] {
        guard let target = target as? SourceModuleTarget else {
            return []
        }
        
        let swiftFiles = target.sourceFiles(withSuffix: "swift")
        
        return try swiftFiles.map {
            let inputPath = $0.url
            
            return .buildCommand(
                displayName: "Analyzing energy consumption",
                executable: try context.tool(named: "EnergyUsageAnalyzer").url,
                arguments: [
                    "-i", inputPath.path
                ],
                inputFiles: [inputPath.standardizedFileURL]
            )
        }
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension EnergyUsageAnalyzerPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(
        context: XcodePluginContext,
        target: XcodeTarget
    ) throws -> [Command] {
        let swiftFiles = target.inputFiles.filter { $0.url.pathExtension == "swift" }
        
        return try swiftFiles.map {
            let inputPath = $0.url
            
            return .buildCommand(
                displayName: "Analyzing energy consumption",
                executable: try context.tool(named: "EnergyUsageAnalyzer").url,
                arguments: [
                    "-i", inputPath.path
                ],
                inputFiles: [inputPath.standardizedFileURL]
            )
        }
    }
}
#endif
