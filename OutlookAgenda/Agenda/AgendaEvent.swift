import Foundation

struct Person {
    var avatar: String?
}

struct AgendaEvent {
    var title: String?
    var content: String?
    var dateInterval: DateInterval?
    var participants: [Person]?
    var location: String?
}
