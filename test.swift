import SwiftUI
import Combine

class CombineTimerManager: ObservableObject {
    private var cancellable: AnyCancellable?
    private var isWorking = false

    func startTimer() {
        cancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { date in
                print("Combine Timer Tick: \(date)")
            }
        isWorking = true
    }

    func stopTimer() {
        isWorking = false
        print("Combine Timer Stopped")
    }
}

let manager = CombineTimerManager()
manager.startTimer()

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    manager.stopTimer()
}
