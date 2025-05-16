import Foundation

final class TolerantTimer {
    private var timer: Timer?

    func startTimer() {
        timer = Timer(timeInterval: 1.0, repeats: true) { _ in
            print("Tick at: \(Date())")
        }
        
        
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

let timerObject = TolerantTimer()
timerObject.startTimer()
