import Foundation
import SwiftSyntax

class BlurManager: EnergyVisitable {
    
    private var modifierViews: [String] = []
    private var propertyViews: [String] = []

    func analyze(_ sourceFile: SourceFileSyntax) {
        let modifierVisitor = BlurModifierVisitor(viewMode: .sourceAccurate)
        modifierVisitor.walk(sourceFile)
        let propertyVisitor = BlurPropertyVisitor(viewMode: .sourceAccurate)
        propertyVisitor.walk(sourceFile)
        
        modifierViews = modifierVisitor.getViews()

        propertyViews = propertyVisitor.getViews()
        
        if !modifierViews.isEmpty {
            print("\nFound SwiftUI blur: ")
            modifierViews.forEach { print("\($0)") }
        }
        
        if !propertyViews.isEmpty {
            print("\nFound UIKit blur: ")
            propertyViews.forEach { print("\($0)") }
        }
    }
    
    func getModidierViews() -> [String] {
        modifierViews
    }
    
    func getPropertyViews() -> [String] {
        propertyViews
    }
}
