@testable import OutlookAgenda
import XCTest

// Just add two test for demo
class AgendaViewControllerTests: XCTestCase {
    
    private var fakeCalendarDataSource: FakeCalendarDataSource!
    private var agendaVC: AgendaViewController!
    private var fakeDelegate: FakeAgendaViewControllerDelegate!
    
    override func setUp() {
        super.setUp()
        
        fakeCalendarDataSource = FakeCalendarDataSource(calendar: CalendarCalculator.calendar, previousWeeksCount: 10, afterWeeksCount: 10)!
        agendaVC = AgendaViewController(calendarDataSource: fakeCalendarDataSource, eventsDataSource: AgendaEventsDataSource())
        fakeDelegate = FakeAgendaViewControllerDelegate()
    }
    
    func testAllDaysCountIsRight() {
        agendaVC.showView()
        let agendaTableView = agendaVC.view.viewWithAccessibilityIdentifier("tableView", classType: UITableView.self)!
        XCTAssertEqual(agendaTableView.numberOfSections, fakeCalendarDataSource.allDaysCount, "The Agenda table view sections count\(agendaTableView.numberOfSections) should be \(fakeCalendarDataSource.allDaysCount)")
    }
    
    func testDonotCallDelegateWhenScrollTableViewProgram() {
        agendaVC.delegate = fakeDelegate
        agendaVC.showView()
        let agendaTableView = agendaVC.view.viewWithAccessibilityIdentifier("tableView", classType: UITableView.self)!
        agendaTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        
        XCTAssertFalse(fakeDelegate.isBeCalledByAgendaViewController)
    }
}

class FakeAgendaViewControllerDelegate: AgendaViewControllerDelegate {
    
    var isBeCalledByAgendaViewController = false
    
    func agendaViewControllerBeginDragging(_ agendaViewController: AgendaViewController) {
    }
    
    func agendaViewController(_ agendaViewController: AgendaViewController, didScrollTo dateOrder: Int) {
        isBeCalledByAgendaViewController = true
    }
}
