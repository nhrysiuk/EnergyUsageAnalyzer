import PackagePlugin
import Foundation

@main
struct EnergyUsageAnalyzerPlugin: BuildToolPlugin {
    
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        guard let target = target as? SourceModuleTarget else {
            return []
        }
        
        let swiftFiles = target.sourceFiles(withSuffix: "swift")
        
        let configURL = context.package.directoryURL.appendingPathComponent("energy-analyzer.yml")
        
        let configExists = FileManager.default.fileExists(atPath: configURL.path)
        
        
        return try swiftFiles.map { file in
            var args = ["-i", file.url.path]
            if configExists {
                args += ["--config", configURL.path]
            }
            
            return .buildCommand(
                displayName: "Analyzing energy consumption",
                executable: try context.tool(named: "EnergyUsageAnalyzer").url,
                arguments: args,
                inputFiles: [file.url] + (configExists ? [configURL] : []),
                outputFiles: []
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
        
        let configURL = context.xcodeProject.directoryURL.appending(path: "energy-analyzer.yml")
        let configExists = FileManager.default.fileExists(atPath: configURL.path)
        
        return try swiftFiles.map { file in
            var args: [String] = ["-i", file.url.path]
            if configExists {
                args.append(contentsOf: ["--config-path", configURL.path])
            }
            
            return .buildCommand(
                displayName: "Analyzing energy consumption",
                executable: try context.tool(named: "EnergyUsageAnalyzer").url,
                arguments: args,
                inputFiles: [file.url] + (configExists ? [configURL] : []),
                outputFiles: []
            )
        }
    }
}
#endif
