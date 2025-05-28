import Foundation

struct Const {
    func getAllCoordinators(disabled: [String]) -> [EnergyCoordinator] {
        let all: [EnergyCoordinator] = [BluetoothCoordinator(), InlineMethodCoordinator(), InstanceFunctionsCoordinator(), DrawAllocationCoordinator(), ParameterObjectCoordinator(), OpacityCoordinator(), BlurCoordinator(), ShadowCoordinator(), LocationStopCoordinator(), LocationAccuracyCoordinator(), PublishTimerCoordinator(), ScheduledTimerCoordinator(), ToleranceTimerCoordinator()]
        
        return all.filter { !disabled.contains($0.identifier) }
    }
}
