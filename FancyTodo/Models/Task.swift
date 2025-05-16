import Foundation

struct Task {
    let id: UUID = UUID()
    let title: String
    var isCompleted: Bool = false
    
    mutating func toggleCompletion() {
        self.isCompleted.toggle()
    }
}
