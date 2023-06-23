//
//  StateMachine.swift
//  
//
//  Created by Nutan Niraula on 2/6/23.
//

import Foundation

// The idea is to have various layers of machines like one with logger, one with undo/redo etc but core will be simple
public protocol StateMachineProtocol {
    associatedtype S
    associatedtype E
    var didChangeResult: ((Result<S, Error>) -> Void)? { get set }
    func changeState(for event: E) -> Result<S, Error>
}

public class StateMachine<S: State, E: Event>: StateMachineProtocol where S.RawValue: FixedWidthInteger {
    
    public typealias Transition = (initialState: S, event: E, finalState: S)
    
    private(set) var currentState: S
    private(set) var transitions: [Transition] = []
    
    var allowedEvents: [S: [E]] = [:]
    var eventProperties: [E: [Transition]] = [:]
    
    public var didChangeResult: ((Result<S, Error>) -> Void)?
    
    public init?(currentState: S = S(rawValue: 0)!, transitions: [Transition]) {
        self.currentState = currentState
        self.transitions = transitions
        if !setInternalDataStructures(from: self.transitions) { return nil }
    }
    
    private func setInternalDataStructures(from transitionInfo: [Transition]) -> Bool {
        var dataAdditionSuccess = true
        
        for transition in transitionInfo {
            
            let initialState = transition.initialState
            let event = transition.event
            
            if allowedEvents[initialState] == nil {
                allowedEvents[initialState] = [event]
            } else {
                let containsSameEvent = allowedEvents[initialState]!.contains(event)
                if !containsSameEvent {
                    allowedEvents[initialState]?.append(event)
                } else {
                    dataAdditionSuccess = false
                    assert(dataAdditionSuccess, "\(initialState) has two or more same \(event) events but multiple destinations")
                    break
                }
            }
            
            
            if eventProperties[event] == nil {
                eventProperties[event] = [transition]
            } else if !eventProperties[event]!.contains(where: { $0 == transition }) {
                eventProperties[event]?.append(transition)
            }
            
        }
        
        return dataAdditionSuccess
    }
    
    private func checkIfAnyStateHasMultipleTransitionForSameEvent() -> Bool {
        
        return false
    }
    
    @discardableResult
    public func changeState(for event: E) -> Result<S, Error> {
        guard allowedEvents[currentState]!.contains(event) else {
            let error = StateError.impossible("\(currentState) cannot \(event)")
            didChangeResult?(.failure(error))
            return .failure(error)
        }
        event.handleSideEffect()
        let finalState = transitions(forEvent: event).first(where: {$0.initialState == currentState})!.finalState
        currentState = finalState
        didChangeResult?(.success(currentState))
        return .success(currentState)
    }
}

extension StateMachine {
    func events(forState state: S) -> [E] {
        return allowedEvents[state]!
    }

    func nextPossibleEvents() -> [E] {
        return allowedEvents[currentState]!
    }

    func transitions(forEvent event: E) -> [Transition] {
        return eventProperties[event]!
    }
}
