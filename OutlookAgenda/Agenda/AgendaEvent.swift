import Foundation

struct Person {
    var name: String?
    var avatar: String?
    var email: String?
}

struct AgendaEvent {
    var title: String?
    var content: String?
    var dateInterval: DateInterval?
    var participant: [Person]?
    var location: String?
}
