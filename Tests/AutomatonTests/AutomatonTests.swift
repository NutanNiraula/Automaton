import XCTest
@testable import Automaton

final class AutomatonTests: XCTestCase {
    
    // Traffic light
    enum TrafficLight: Int, State {
        case red, green, yellow
        
        enum Transition: Event {
            case next
        }
    }
    
    func testTrafficLight() throws {
        
        guard let stateMachine = StateMachine<TrafficLight, TrafficLight.Transition>(
            transitions: [
                (.red, .next, .green),
                (.green, .next, .yellow),
                (.yellow, .next, .red)
            ]
        ) else {
            XCTFail("Invalid machine")
            return
        }
        
        XCTAssertEqual(stateMachine.allowedEvents, [.red: [.next], .green: [.next], .yellow: [.next]])
        XCTAssertEqual(stateMachine.currentState, .red)
        XCTAssertEqual(stateMachine.nextPossibleEvents(), [.next])
        XCTAssert(stateMachine.transitions(forEvent: .next).first! == (.red, .next, .green))
        
        switch stateMachine.changeState(for: .next) {
        case .success(let state):
            XCTAssertEqual(state, .green)
        case .failure(_):
            XCTFail("This cannot fail")
        }
        
        let markup = MermaidJSConverter.convert(stateMachine.transitions)
        print(markup)
        XCTAssertEqual(
            markup,
            """
            stateDiagram-v2
            \tred --> green :next
            \tgreen --> yellow :next
            \tyellow --> red :next
            
            """
        )
        
    }
}
