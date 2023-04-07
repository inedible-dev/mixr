import Foundation

struct MixControl: Codable, Identifiable {
    var id = UUID().uuidString
    var name: String = "New Track"
    var url: Data?
    var gain: Float = 0.0
    
    init(_ count: Int) {
        name = "Track \(count + 1)"
    }
}
