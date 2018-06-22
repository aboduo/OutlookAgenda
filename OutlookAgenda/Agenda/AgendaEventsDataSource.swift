import Foundation

class AgendaEventsDataSource {
    
    static private var agendaEvents: [String: [AgendaEvent]] = {
        let day0 = Date().startOfDay()
        let dateInterval0 = DateInterval(start: day0.add(hours: 9)!, end: day0.add(hours: 11)!)
        let dateInterval1 = DateInterval(start: day0.add(hours: 13)!, end: day0.add(hours: 15)!)
        let dateInterval2 = DateInterval(start: day0.add(hours: 16)!, end: day0.add(hours: 18)!)
        
        let participants = [Person(avatar: "avatar_default"), Person(avatar: "avatar_default")]
        let event0 = AgendaEvent(title: "I'm title", content: "I'm content", dateInterval: dateInterval0, participant: nil, location: "ShangHai")
        let event1 = AgendaEvent(title: "我是标题", content: "我不是内容", dateInterval: dateInterval1, participant: participants, location: nil)
        let event2 = AgendaEvent(title: "我是标题很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长", content: "我不是内容", dateInterval: dateInterval2, participant: participants, location: "我是地址，很长很长很长很长很长很长很长很长很长很长很长很长很长")
        return [day0.keyForEvents(): [event0, event1, event2]]
    }()
    
    
    /// Get events of specified day using year month and day as key
    func agendaEvents(at day: Date) -> [AgendaEvent]? {
        return AgendaEventsDataSource.agendaEvents[day.keyForEvents()]
    }
}

extension Date {
    private static let dateFormatForEventsKey = "yyyy-M-d"
    
    fileprivate func keyForEvents() -> String {
        return formatString(dateFormat: Date.dateFormatForEventsKey)
    }
}
