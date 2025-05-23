import Foundation
import Yams

struct LinterConfiguration: Decodable {
    let disabledRules: [String]

    enum CodingKeys: String, CodingKey {
        case disabledRules = "disabled_rules"
    }
}

func loadConfiguration(from path: String = "energy-analyzer.yml") -> LinterConfiguration {
    guard FileManager.default.fileExists(atPath: path),
          let yaml = try? String(contentsOfFile: path),
          let config = try? YAMLDecoder().decode(LinterConfiguration.self, from: yaml) else {
        return LinterConfiguration(disabledRules: [])
    }
    
    return config
}
