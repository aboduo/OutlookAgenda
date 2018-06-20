import Foundation

class AgendaDataSource {
    
    static private var agendaEvents: [Date: [AgendaEvent]] = {
        let day0 = Date()
        let event0 = AgendaEvent(title: "I'm title", content: "I'm content", dateInterval: nil, participant: nil, location: "ShangHai")
        
        return [day0: [event0]]
    }()
    
    
    func agendaEvents(at date: Date) -> [AgendaEvent]? {
        return AgendaDataSource.agendaEvents[date]
    }
    
    
}
