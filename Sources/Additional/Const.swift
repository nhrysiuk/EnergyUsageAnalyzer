import Foundation

struct Const {
    let visitors: [any EnergyVisitable] = [BluetoothManager(), InlineMethodManager(), InstanceFunctionsManager(), DrawAllocationManager(), FinalClassManager(), ParameterObjectManager(), OpacityManager(), BlurManager(), ShadowManager(), LocationStopManager(), LocationAccuracyManager(), PublishTimerManager(), ScheduledTimerManager(), ToleranceTimerManager()]
}
