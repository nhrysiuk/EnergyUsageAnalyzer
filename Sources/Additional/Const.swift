import Foundation

struct Const {
    func getAllVisitors(disabled: [String]) -> [EnergyAnalyzer] {
        let all: [EnergyAnalyzer] = [BluetoothAnalyzer(), InlineMethodAnalyzer(), InstanceFunctionsAnalyzer(), DrawAllocationAnalyzer(), ParameterObjectAnalyzer(), OpacityAnalyzer(), BlurAnalyzer(), ShadowAnalyzer(), LocationStopAnalyzer(), LocationAccuracyAnalyzer(), PublishTimerAnalyzer(), ScheduledTimerAnalyzer(), ToleranceTimerAnalyzer()]
        
        return all.filter { !disabled.contains($0.identifier) }
    }
}
