import Foundation

struct FetchTimer {
    var timer = Timer()
    
    mutating func start(timeInterval: Double, action: @escaping () -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) {_ in
            action()
        }
    }

    func stop() {
        timer.invalidate()
    }
}
