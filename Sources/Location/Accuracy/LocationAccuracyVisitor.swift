import SwiftSyntax
import CoreLocation

class LocationAccuracyVisitor: SyntaxVisitor {
    
    private enum AccuracyProperty: String {
        case desiredAccuracy
        case distanceFilter
        
        func processValue(_ node: ExprSyntax) -> (String?, Double?) {
            switch self {
            case .desiredAccuracy:
                if let word = node.as(DeclReferenceExprSyntax.self) {
                    return (word.baseName.text, nil)
                }
            case .distanceFilter:
                if let intLiteral = node.as(IntegerLiteralExprSyntax.self) {
                    return (nil, Double(intLiteral.literal.text))
                }
                if let doubleLiteral = node.as(FloatLiteralExprSyntax.self) {
                    return (nil, Double(doubleLiteral.literal.text))
                }
            }
            return (nil, nil)
        }
    }
    
    private struct AccuracyConfig {
        var accuracyLevel: String
        var distance: CLLocationDistance
        
        static let `default` = AccuracyConfig(
            accuracyLevel: "kCLLocationAccuracyBest",
            distance: 16
        )
    }
    
    private var views: [WarningMessage] = []
    private let filePath: String
    private var codePlacement: (line: Int, column: Int)
    
    init(filePath: String, codePlacement: (Int, Int)) {
        self.filePath = filePath
        self.codePlacement = codePlacement
        super.init(viewMode: .all)
    }
    
    private var config: AccuracyConfig = .default
    
    override func visit(_ node: SequenceExprSyntax) -> SyntaxVisitorContinueKind {
        guard let memberAccess = node.elements.first?.as(MemberAccessExprSyntax.self),
              let property = AccuracyProperty(rawValue: memberAccess.declName.baseName.text),
              let lastElement = node.elements.last else {
            return .visitChildren
        }
        
        let (accuracyValue, distanceValue) = property.processValue(lastElement)
        
        let location = node.startLocation(converter: SourceLocationConverter(fileName: filePath, tree: node.root))
        
        if let accuracyValue = accuracyValue {
            config.accuracyLevel = accuracyValue
            codePlacement = (location.line, location.column)
        } else if let distanceValue = distanceValue {
            config.distance = distanceValue
            codePlacement = (location.line, location.column)
        }
        
        return .visitChildren
    }
    
    func getViews() -> [WarningMessage] {
        return views
    }
    
    func getConfig() -> (accuracyLevel: String, distance: CLLocationDistance) {
        return (config.accuracyLevel, config.distance)
    }
    
    func getLocation() -> (Int, Int) {
        return codePlacement
    }
}
